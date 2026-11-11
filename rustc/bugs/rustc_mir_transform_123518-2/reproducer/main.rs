use std::future::Future;
use std::pin::pin;
use std::task::{Context, Poll, Waker};

fn block_on<F: Future>(f: F) -> F::Output {
    let mut f = pin!(f);
    let mut cx = Context::from_waker(Waker::noop());
    loop {
        if let Poll::Ready(v) = f.as_mut().poll(&mut cx) { return v; }
    }
}

async fn call_once(f: impl AsyncFnOnce()) { f().await }

struct S { a: i32, b: String, c: String }

fn main() {
    block_on(async {
        let mut s = S { a: 1, b: "x".into(), c: "y".into() };
        let c = async || {
            s.a = 2;
            let w = &mut s.b;
            w.push('!');
        };
        s.c.push('?');
        call_once(c).await;
        println!("{} {} {}", s.a, s.b, s.c);
    });
}
