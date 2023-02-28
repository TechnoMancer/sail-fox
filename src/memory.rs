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

  pub fn allocate_page_from_data(&mut self, address: usize, data: &[u8]) -> Result<(), ()> {
    if address & L0_MASK != 0 {
      return Err(());
    }

    return self.map_page(address, MemoryPage::from_data(data)?);
  }

  pub fn allocate_page_from_file<P: AsRef<std::path::Path>>(&mut self, address: usize, path: P) -> Result<(), ()> {
    if address & L0_MASK != 0 {
      return Err(());
    }

    return self.map_page(address, MemoryPage::from_file(path)?);
  }

  fn map_page(&mut self, address: usize, page: MemoryPage) -> Result<(), ()> {
    let result = self.map.map(address, &page);

    self.blocks.push(page);

    return result;
  }

  pub fn read_u8(&self, address: usize) -> Result<u8, ()> {
    return self.map.read_u8(address);
  }
  
  pub fn read_u16(&self, address: usize) -> Result<u16, ()> {
    if address & 0x1 != 0 {
      return Err(());
    }

    return self.map.read_u16(address);
  }

  pub fn write_u8(&self, address: usize, data: u8) -> Result<(), ()> {
    return self.map.write_u8(address, data);
  }
  
  pub fn write_u16(&self, address: usize, data: u16) -> Result<(), ()> {
    if address & 0x1 != 0 {
      return Err(());
    }

    return self.map.write_u16(address, data);
  }
}

pub struct MemoryPage(usize);

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
