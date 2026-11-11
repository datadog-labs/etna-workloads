fn main() {
    let mut chars = "abc".chars();
    for _c in chars.by_ref() {
        chars.next();
    }
}
