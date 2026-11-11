use std::future::Future;
use std::pin::pin;
use std::task::{Context, Poll, Waker};
fn consume(_: String) {}
fn block_on<F: Future>(f: F) -> F::Output {
    let mut f = pin!(f);
    let mut cx = Context::from_waker(Waker::noop());
    loop { if let Poll::Ready(v) = f.as_mut().poll(&mut cx) { return v; } }
}
fn main() {
    block_on(async {
        let x = 1i32;
        let s = String::new();
        let c = async move || {
            println!("{x}");
            consume(s);
        };
        c().await;
    });
}
