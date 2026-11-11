fn is_fn<F: Fn(&'static str) -> Fut, Fut: std::future::Future<Output = ()>>(_: F) {}
fn main() {
    is_fn(async |x: &'static str| { let _ = x; });
}
