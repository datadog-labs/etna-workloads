#![feature(fn_traits)]
#![feature(unboxed_closures)]
fn foo(_a: u32) {}
fn main() {
    let f: Box<dyn Fn(u32)> = Box::new(foo);
    Fn::call(&f, (0,));
    println!("ok");
}
