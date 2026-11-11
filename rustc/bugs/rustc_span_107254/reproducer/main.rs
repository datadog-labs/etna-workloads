fn consume(_: &i32) {}
async fn foo() {
    consume(&async { Box::new(7_i32) }.await);
}
fn main() {}
