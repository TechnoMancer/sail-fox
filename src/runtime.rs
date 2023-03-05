use std::process::exit;

use crate::sail;

extern {
  fn model_pre_exit();

  fn setup_library();
  fn cleanup_library();
}

#[no_mangle]
pub unsafe extern "C" fn setup_rts() {
  setup_library();
}

#[no_mangle]
pub unsafe extern "C" fn cleanup_rts() {
  cleanup_library();
}

#[no_mangle]
pub unsafe extern "C" fn sail_exit(_: sail::unit) -> ! {
  model_pre_exit();

  exit(0);
}
