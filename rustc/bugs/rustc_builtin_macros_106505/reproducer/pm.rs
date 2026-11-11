extern crate proc_macro;
use proc_macro::TokenStream;
#[proc_macro]
pub fn cap(_: TokenStream) -> TokenStream {
    r#"{ let x = 5; format!("{x}") }"#.parse().unwrap()
}
