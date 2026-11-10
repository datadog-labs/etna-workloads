extern crate proc_macro;
use proc_macro::*;
#[proc_macro_attribute]
pub fn show(_a: TokenStream, i: TokenStream) -> TokenStream {
    for t in i.clone() { println!("{:?}", t.span()); }
    i
}
