trait LocalTrait {}
fn use_local_trait(_: impl LocalTrait) {}
fn main() { use_local_trait(()); }
