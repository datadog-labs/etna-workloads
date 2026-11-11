macro_rules! bar {
    ($tt:tt) => {
        pub const $tt: () = {};
    };
}
bar!(_);
fn main() {}
