use std::collections::HashMap;
struct Test { v: i32 }
fn main() {
    let mut map = HashMap::new();
    map.insert("a", Test { v: 0 });
    let x = map.iter();
    for (_k, v) in x {
        v.v += 1;
    }
}
