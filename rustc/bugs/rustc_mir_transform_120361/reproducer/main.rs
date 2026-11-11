use std::future::Future;
use std::pin::pin;
use std::task::*;
fn block_on<F: Future>(f: F) -> F::Output {
    let mut f = pin!(f);
    let mut cx = Context::from_waker(Waker::noop());
    loop { if let Poll::Ready(v) = f.as_mut().poll(&mut cx) { return v; } }
}
struct DropMe(i32);
impl Drop for DropMe { fn drop(&mut self) { println!("{} was dropped", self.0); } }
async fn call_once(f: impl AsyncFnOnce()) {
    println!("before call");
    let fut = Box::pin(f());
    println!("after call");
    drop(fut);
    println!("future dropped");
}
fn main() {
    block_on(async {
        let d = DropMe(42);
        let c = async move || { let d = &d; println!("called"); };
        call_once(c).await;
        println!("after");
    });
}
