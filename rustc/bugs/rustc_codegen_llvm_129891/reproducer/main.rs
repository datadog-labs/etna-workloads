#![crate_type = "lib"]
use std::arch::naked_asm;
#[unsafe(naked)]
#[no_mangle]
pub extern "C" fn page_fault_handler() {
    naked_asm!("ud2");
}
