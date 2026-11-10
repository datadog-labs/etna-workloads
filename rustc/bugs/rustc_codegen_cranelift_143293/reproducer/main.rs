#![crate_type = "lib"]

use core::arch::naked_asm;

struct Thing;
trait MyTrait {
    #[unsafe(naked)]
    extern "C" fn my_naked_function(&self) {
        naked_asm!("ret")
    }
}
impl MyTrait for Thing {}

pub fn call() {
    const F: extern "C" fn(&Thing) = Thing::my_naked_function;
    (F)(&Thing);
}
