fn main() {
    fn x(a: &char) {
        let &b = a;
        b.make_ascii_uppercase();
    }
}
