#[macro_export]
macro_rules! q {
    () => {{
        fn items() -> impl IntoIterator<Item = i32> { vec![1, 2, 3] }
        let other = items().map(|i| i + 1);
        other
    }};
}
