extern crate proc_macro;
use proc_macro::TokenStream;
#[proc_macro_attribute]
pub fn identity_attr(_: TokenStream, input: TokenStream) -> TokenStream { input }
