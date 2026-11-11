trait Bar<X> { type Assoc; }
fn f<T: Bar<u8> + Bar<u16>>(v: <T as Bar<u8>>::Assoc) -> <T as Bar<u16>>::Assoc {
    v
}
fn main() {}
