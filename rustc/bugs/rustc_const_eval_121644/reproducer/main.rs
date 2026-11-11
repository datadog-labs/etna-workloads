static DOUBLE_REF: &&i32 = &&99;
static ONE_STEP_ABOVE: &i32 = *DOUBLE_REF;
static mut DOUBLE_REF_MUT: &mut &mut i32 = &mut &mut 99;
static mut ONE_STEP_ABOVE_MUT: &mut i32 = unsafe { *DOUBLE_REF_MUT };
pub static LOCAL_FOO: &'static i32 = &41;
pub static LOCAL_BAR: &'static i32 = LOCAL_FOO;
fn main() {
    unsafe {
        println!("{}", *DOUBLE_REF as *const i32 == ONE_STEP_ABOVE as *const i32);
        println!("{}", *DOUBLE_REF_MUT as *mut i32 == ONE_STEP_ABOVE_MUT as *mut i32);
        println!("{}", LOCAL_FOO as *const i32 == LOCAL_BAR as *const i32);
    }
}
