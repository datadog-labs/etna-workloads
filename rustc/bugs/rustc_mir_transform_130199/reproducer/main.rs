use std::future::Future;
use std::pin::pin;
use std::task::*;
fn block_on<F: Future>(f: F) -> F::Output {
    let mut f = pin!(f);
    let mut cx = Context::from_waker(Waker::noop());
    loop { if let Poll::Ready(v) = f.as_mut().poll(&mut cx) { return v; } }
}
async fn empty() {}
pub async fn call_once<F: AsyncFnOnce()>(f: F) { f().await; }
fn main() {
    block_on(call_once(async || empty().await));
    println!("ok");
}
