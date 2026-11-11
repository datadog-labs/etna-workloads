struct S { field_name: () }
fn main() {
    match (S { field_name: () }) {
        S { ref field_name: _foo } => {}
    }
}
