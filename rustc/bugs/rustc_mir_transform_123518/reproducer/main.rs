use std::future::Future;
use std::pin::pin;
use std::task::*;

async fn call_once(f: impl AsyncFnOnce()) { f().await; }

pub async fn async_closure(x: &mut i32) {
    let c = async move || {
        *x += 1;
    };
    call_once(c).await;
}

fn main() {
    let mut x = 0;
    {
        let mut f = pin!(async_closure(&mut x));
        let mut cx = Context::from_waker(Waker::noop());
        while let Poll::Pending = f.as_mut().poll(&mut cx) {}
    }
    println!("x = {}", x);
}
