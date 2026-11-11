extern crate proc_macro_repro;
struct Arg(std::marker::PhantomPinned);
#[proc_macro_repro::repro]
fn f(arg: &mut Arg);
