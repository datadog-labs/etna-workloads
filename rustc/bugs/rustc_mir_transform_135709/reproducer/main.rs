fn main() {
    let local = (&[1u32, 2, 3] as &[u32])[1];
    println!("{}", local);
}
