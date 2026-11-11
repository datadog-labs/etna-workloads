#[non_exhaustive]
pub struct Foo { pub my_field: u32, private_field: u32 }
#[non_exhaustive]
pub struct Bar { pub my_field: u32, pub missing_field: u32 }
