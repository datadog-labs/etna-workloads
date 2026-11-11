fn bytes_at_home(x: [u8; 4]) -> u32 {
    unsafe { zerocopy::transmute!(x) }
}
fn main() {}
