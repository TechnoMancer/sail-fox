use std::sync::Mutex;

pub mod assembler;

mod memory;
mod runtime;
mod sail;
mod state;

pub use state::State;

pub struct Foxmulator {
  _hidden: usize
}

static mut MUTEX: Mutex<()> = Mutex::new(());
static mut FOXMULATOR: Option<Foxmulator> = Some(Foxmulator { _hidden: 0 });

extern {
  fn model_init();
  fn model_fini();

  // Always returns UNIT (0), so pretending it does not return
  fn zmain(_: sail::unit);
}

impl Foxmulator {
  pub fn singleton() -> Option<Foxmulator> {
    unsafe {
      let _guard = MUTEX.lock().unwrap();

      let mut value = None;
      std::mem::swap(&mut value, &mut FOXMULATOR);

      if value.is_some() {
        state::sail_interop::STATE = state::State::new();
        memory::sail_interop::MEMORY = memory::Memory::new();
        model_init();
      }

      return value;
    }
  }

  pub fn run(&mut self) {
    unsafe { zmain(0) };
  }

  pub fn map_memory(&mut self, address: usize) -> Result<(), ()> {  
    return unsafe { memory::sail_interop::MEMORY.allocate_page(address) };
  }
  
  pub fn map_binary(&mut self, address: usize, path: &str) -> Result<(), ()> {
    return unsafe { memory::sail_interop::MEMORY.allocate_page_from_file(address, path) };
  }
  
  pub fn map_assembly(&mut self, address: usize, asm: &str) -> Result<(), ()> {
    return unsafe { memory::sail_interop::MEMORY.allocate_page_from_assembly(address, asm) };
  }

  pub fn state(&mut self) -> state::State {
    return unsafe { state::sail_interop::STATE };
  }

  pub fn set_state(&mut self, state: state::State) {
    unsafe { state::sail_interop::STATE = state };
  }
}

impl Drop for Foxmulator {
  fn drop(&mut self) {
    unsafe {
      model_fini();

      let _guard = MUTEX.lock().unwrap();

      FOXMULATOR = Some(Foxmulator { _hidden: 0 });
    }
  }
}
