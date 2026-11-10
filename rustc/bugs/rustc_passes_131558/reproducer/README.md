Compiling a function with both `#[no_mangle]` and `#[export_name]` should emit an `unused_attributes` warning (the `no_mangle` is ignored). The injected compiler omits that warning.
