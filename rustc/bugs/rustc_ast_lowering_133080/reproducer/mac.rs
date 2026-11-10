#[macro_export]
macro_rules! macro_rpit {
    () => {
        fn test_mbe(x: &Vec<i32>) -> impl std::fmt::Display {
            x[0]
        }
    };
}
