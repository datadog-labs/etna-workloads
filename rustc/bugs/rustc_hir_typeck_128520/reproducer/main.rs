fn wrapper(f: impl Fn(String)) -> impl AsyncFn(String) {
    async move |s| f(s)
}
fn main() { let _ = wrapper(|_s| {}); }
