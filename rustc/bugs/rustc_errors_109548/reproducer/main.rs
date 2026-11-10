// Test for #109537: ensure that column numbers are correctly generated when using hard tabs.
//@ aux-build:aux.rs

// ignore-tidy-file-tab

extern crate aux;

fn main() {
	let s = aux::S;
	s.method();
	//~^ ERROR method `method` is private
}
