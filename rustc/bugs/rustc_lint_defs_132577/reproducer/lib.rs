#[macro_export]
macro_rules! m { () => { #[cfg(my_lib_cfg)] fn f() {} }; }
