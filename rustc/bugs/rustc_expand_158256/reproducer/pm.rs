extern crate proc_macro;
use proc_macro::*;
#[proc_macro]
pub fn run(_: TokenStream) -> TokenStream {
    println!("{:?}", "r#".parse::<TokenStream>().is_ok());
    println!("{:?}", "r#".parse::<Literal>().is_ok());
    TokenStream::new()
}
