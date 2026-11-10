#![crate_type="lib"]

#![feature(coroutines, stmt_expr_attributes)]
pub fn run<T>(a: T) {
    let _ = #[coroutine]
    move || {
        drop(a);
        yield;
    };
}
