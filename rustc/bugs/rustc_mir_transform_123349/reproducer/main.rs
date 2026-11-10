use std::future::Future;
use std::pin::pin;
use std::task::*;
fn block_on<F: Future>(f: F) -> F::Output {
    let mut f = pin!(f);
    let mut cx = Context::from_waker(Waker::noop());
    loop { if let Poll::Ready(v) = f.as_mut().poll(&mut cx) { return v; } }
}
#[derive(Debug)]
struct Hello(i32);
async fn call_once<T>(f: impl AsyncFnOnce() -> T) -> T { f().await }
fn main() {
    block_on(async {
        let x = Hello(0);
        let c = async || { println!("{x:?}"); };
        call_once(c).await;
    });
}
