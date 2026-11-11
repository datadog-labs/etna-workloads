Compiles a fn with a `&x: &i32` parameter that mutably borrows x; the borrowck error's help suggestion should be `&(mut x)` but the injected compiler suggests the invalid `&mut x`.
