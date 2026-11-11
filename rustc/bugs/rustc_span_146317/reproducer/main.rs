#[cfg(panic = "bogus")]
fn main() {}
#[cfg(not(panic = "bogus"))]
fn main() {}
