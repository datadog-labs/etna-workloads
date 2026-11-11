use std::future::Future;
use std::pin::pin;
use std::task::*;

async fn f(_arg: &i32) {}

async fn func<F>(f: F)
where
    F: for<'a> AsyncFn(&'a i32),
{
    let x: i32 = 0;
    f(&x).await;
}

fn main() {
    let w = Waker::noop();
    let mut cx = Context::from_waker(&w);
    let mut fut = pin!(func(f));
    let _ = fut.as_mut().poll(&mut cx);
    println!("done");
}
