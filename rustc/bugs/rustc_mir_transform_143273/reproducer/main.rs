#[repr(i8)]
#[derive(Debug)]
enum E { A = -3, B = 1 }
fn main() {
    let x: i8 = -3;
    let e: E = unsafe { std::mem::transmute(x) };
    println!("{:?}", e);
}
