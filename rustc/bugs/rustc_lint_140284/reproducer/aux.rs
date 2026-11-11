
#[macro_export]
macro_rules! transmute {
    ($e:expr) => {{
        let e = $e;
        std::mem::transmute(e)
    }};
}
