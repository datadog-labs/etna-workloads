use std::arch::asm;
fn main() {
    unsafe {
        asm!(
            "",
            "invalid_instruction"
        );
    }
}
