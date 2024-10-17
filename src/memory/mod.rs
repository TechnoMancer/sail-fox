use std::io::{Read, Write};

use crate::assembler;

const PAGE_SHIFT: usize = 14;
const PAGE_SIZE: usize = 16 * 1024;

const L0_MASK: usize = PAGE_SIZE - 1;
const L1_MASK: usize = 2048 * PAGE_SIZE - 1;

pub struct Memory {
  map: MemoryMap,
  blocks: Vec<MemoryPage>
}

impl Memory {
  pub const fn new() -> Memory {
    return Memory {
      map: MemoryMap::new(),
      blocks: vec![]
    };
  }

  pub fn allocate_page(&mut self, address: usize) -> Result<(), ()> {
    if address & L0_MASK != 0 {
      return Err(());
    }

    return self.map_page(address, MemoryPage::new());
  }

  pub fn allocate_page_from_file<P: AsRef<std::path::Path>>(&mut self, address: usize, path: P) -> Result<(), ()> {
    if address & L0_MASK != 0 {
      return Err(());
    }
    let mut addr = address;

    if let Ok(data) = std::fs::read(path) {
      for chunk in data.chunks(PAGE_SIZE) {
        self.map_page(addr, MemoryPage::from_data(chunk)?)?;
        addr += chunk.len();
      }
      Ok(())
    }
    else {
       Err(())
    }
  }

  pub fn allocate_page_from_assembly(&mut self, address: usize, asm: &str) -> Result<(), ()> {
    if address & L0_MASK != 0 {
      return Err(());
    }

    let binary = assembler::assemble(asm)?;

    return self.map_page(address, MemoryPage::from_data(&binary)?);

  }

  fn map_page(&mut self, address: usize, page: MemoryPage) -> Result<(), ()> {
    let result = self.map.map(address, &page);

    self.blocks.push(page);

    return result;
  }

  pub fn read_u8(&self, address: usize) -> Result<u8, ()> {
    match address {
      // console status: 
      // first byte is number of chars in tx queue
      // second byte is available chars in rx queue
      0xfffa => {Ok(0)},
      0xfffb => {Ok(0b1)},
      // console tx register, reads as 0
      0xfffc => {Ok(0)},
      0xfffd => {Ok(0)},
      // console rx register, reads as single byte read from stdin
      0xfffe => {Ok(0)},
      0xffff => {
        let mut buf = [0u8; 1];
        std::io::stdin().take(1).read_exact(&mut buf).map_err(|_| ())?;
        Ok(buf[0])
      },
      _ => self.map.read_u8(address)
    }
  }
  
  pub fn read_u16(&self, address: usize) -> Result<u16, ()> {
    if address & 0x1 != 0 {
      return Err(());
    }

    return match address {
      // See read_u8
      0xfffa => {Ok(0b1)},
      0xfffc => {Ok(0)},
      0xfffe => {
        let mut buf = [0u8; 1];
        std::io::stdin().take(1).read_exact(&mut buf).map_err(|_| ())?;
        Ok(buf[0] as u16)
      },
      _ => self.map.read_u16(address)
    }
  }

  pub fn write_u8(&self, address: usize, data: u8) -> Result<(), ()> {
    return match address {
      // Console status register, ignores writes
      0xfffa => {Ok(())},
      0xfffb => {Ok(())},
      // Console tx register, writes byte in lower half to console
      0xfffc => {Ok(())},
      0xfffd => {
        let buf = [data];
        std::io::stdout().write_all(&buf).map_err(|_| ())?;
        Ok(())
      },
      // Console rx register, ignores reads
      0xfffe => {Ok(())},
      0xffff => {Ok(())},
      _ => self.map.write_u8(address, data)
    }
  }
  
  pub fn write_u16(&self, address: usize, data: u16) -> Result<(), ()> {
    if address & 0x1 != 0 {
      return Err(());
    }

    return match address {
      // See write_u8
      0xfffa => {Ok(())},
      0xfffc => {
        let buf = [(u16::from_be(data) & 0xff) as u8];
        //println!("Printing: {:?}", &buf);
        std::io::stdout().write_all(&buf).map_err(|_| ())?;
        Ok(())
      },
      0xfffe => {Ok(())},
      _ => self.map.write_u16(address, data)
    }
  }
}

struct MemoryPage(usize);

impl MemoryPage {
  pub fn new() -> MemoryPage {
    unsafe {
      let ptr = libc::mmap(
          std::ptr::null_mut(),
          PAGE_SIZE as libc::size_t,
          libc::PROT_READ | libc::PROT_WRITE,
          libc::MAP_PRIVATE | libc::MAP_ANON,
          -1,
          0 as libc::off_t,
      );

      if ptr == libc::MAP_FAILED {
        // TODO: Actually handle error here
        panic!("Failed to allocate memory block for some reason");
      } else {
        return MemoryPage(ptr as usize);
      }
    }
  }

  pub fn from_data(data: &[u8]) -> Result<MemoryPage, ()> {
    let block = MemoryPage::new();

    if data.len() > PAGE_SIZE {
      return Err(());
    }

    for i in 0 .. data.len() {
      block.write_u8(i, data[i])?;
    }
    
    return Ok(block);
  }

  pub fn from_file<P: AsRef<std::path::Path>>(path: P) -> Result<MemoryPage, ()> {
    if let Ok(data) = std::fs::read(path) {
      return MemoryPage::from_data(&data);
    }

    // TODO: Actually handle error here
    return Err(());
  }
  
  pub fn read_u8(&self, address: usize) -> Result<u8, ()> {
    let pointer = self.0 as *const u8;
    let offset = address & L0_MASK;

    return Ok(unsafe { *pointer.offset(offset as isize) });
  }
  
  pub fn read_u16(&self, address: usize) -> Result<u16, ()> {
    let pointer = self.0 as *const u16;
    let offset = (address & L0_MASK) >> 1;

    return Ok(unsafe { *pointer.offset(offset as isize) });
  }

  pub fn write_u8(&self, address: usize, data: u8) -> Result<(), ()> {
    let pointer = self.0 as *mut u8;
    let offset = address & L0_MASK;

    unsafe { *pointer.offset(offset as isize) = data };

    return Ok(());
  }
  
  pub fn write_u16(&self, address: usize, data: u16) -> Result<(), ()> {
    let pointer = self.0 as *mut u16;
    let offset = (address & L0_MASK) >> 1;

    unsafe { *pointer.offset(offset as isize) = data };

    return Ok(());
  }
}

struct MemoryMap([usize; 2048]);

impl MemoryMap {
  pub const fn new() -> MemoryMap {
    return MemoryMap([0; 2048]);
  }

  pub fn map(&mut self, address: usize, page: &MemoryPage) -> Result<(), ()> {
    self.0[(address & L1_MASK) >> PAGE_SHIFT] = page.0 | 0x1;

    return Ok(());
  }

  pub fn read_u8(&self, address: usize) -> Result<u8, ()> {
    let entry = &self.0[(address & L1_MASK) >> PAGE_SHIFT];

    match entry & 0x7 {
      0x0 => return Err(()),
      0x1 => return MemoryPage(entry & !0x7).read_u8(address),
      _ => panic!("This really never should happen")
    };
  }
  
  pub fn read_u16(&self, address: usize) -> Result<u16, ()> {
    let entry = &self.0[(address & L1_MASK) >> PAGE_SHIFT];

    match entry & 0x7 {
      0x0 => return Err(()),
      0x1 => return MemoryPage(entry & !0x7).read_u16(address),
      _ => panic!("This really never should happen")
    };
  }

  pub fn write_u8(&self, address: usize, data: u8) -> Result<(), ()> {
    let entry = &self.0[(address & L1_MASK) >> PAGE_SHIFT];

    match entry & 0x7 {
      0x0 => return Err(()),
      0x1 => return MemoryPage(entry & !0x7).write_u8(address, data),
      _ => panic!("This really never should happen")
    };
  }

  pub fn write_u16(&self, address: usize, data: u16) -> Result<(), ()> {
    let entry = &self.0[(address & L1_MASK) >> PAGE_SHIFT];

    match entry & 0x7 {
      0x0 => return Err(()),
      0x1 => return MemoryPage(entry & !0x7).write_u16(address, data),
      _ => panic!("This really never should happen")
    };
  }
}

pub mod sail_interop;
