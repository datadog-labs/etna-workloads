extern crate direct_dep_with_multiple_reexports as direct_dep;
struct Struct;
fn main() {
    let _: direct_dep::Struct = Struct;
}
