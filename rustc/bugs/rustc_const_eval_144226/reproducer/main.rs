extern "C" {
    pub static mut symbol: [i8];
}

fn main() {
    println!("C", unsafe { &symbol });
}
