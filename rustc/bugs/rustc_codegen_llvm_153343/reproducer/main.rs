use std::hint::black_box;
const SNAN32: f32 = f32::from_bits(f32::NAN.to_bits() - 1);
const SNAN64: f64 = f64::from_bits(f64::NAN.to_bits() - 1);
fn main() {
    println!("{}", SNAN32.min(black_box(9.0)));
    println!("{}", black_box(SNAN32).min(-9.0));
    println!("{}", (9.0f32).min(black_box(SNAN32)));
    println!("{}", SNAN64.min(black_box(9.0)));
    println!("{}", black_box(-9.0f64).min(SNAN64));
}
