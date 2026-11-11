use std::future::Future;
use std::pin::pin;
use std::task::*;

fn block_on<T>(fut: impl Future<Output = T>) -> T {
    let mut fut = pin!(fut);
    let ctx = &mut Context::from_waker(Waker::noop());
    loop {
        match fut.as_mut().poll(ctx) {
            Poll::Pending => {}
            Poll::Ready(t) => break t,
        }
    }
}

async fn call_once(f: impl AsyncFnOnce()) {
    f().await;
}

async fn async_main() {
    let x = &mut 0;
    let y = &mut 0;
    let c = async || {
        *x = 1;
        *y = 2;
    };
    call_once(c).await;
    println!("{x} {y}");
}

fn main() {
    block_on(async_main());
}
