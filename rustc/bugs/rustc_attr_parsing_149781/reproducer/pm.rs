extern crate proc_macro;
use proc_macro::TokenStream;
#[proc_macro]
pub fn missing_unsafe(_input: TokenStream) -> TokenStream {
    "#[no_mangle] pub fn abc() {}".parse().unwrap()
}
