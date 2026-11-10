#![crate_type = "lib"]
pub fn f(o: Option<i32>) -> i32 {
    unsafe { o.unwrap_unchecked() }
}
