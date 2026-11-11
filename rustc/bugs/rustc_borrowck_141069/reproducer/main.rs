fn main() {
    let mut s = String::from("hello");
    let mut ref_s = &mut s;
    ref_s = &mut String::from("world");
    print!("r1 = {}", ref_s);
}
