use std::future::Future;
use std::pin::Pin;
pub struct S;
pub fn bar() -> Pin<Box<dyn Future<Output = Result<S, ()>> + 'static>> {
    Box::pin(async move {
        if true {
            Ok(S)
        }
        Err(())
    })
}
fn main() {}
