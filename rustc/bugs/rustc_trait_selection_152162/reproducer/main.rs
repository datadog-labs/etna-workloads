fn main() {
    let o = Some("Hello, world!");
    for s in o.map(|s| s[3..8]) {}
}
