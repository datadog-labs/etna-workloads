use std::future::Future;
fn make() -> impl Future<Output = ()> { async {} }
fn main() {
    let fut = make();
    fut.poll();
}
