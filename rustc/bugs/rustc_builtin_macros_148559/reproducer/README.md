Compiling env!("CARGO_PACKAGE_VERSION") (a typo of CARGO_PKG_VERSION) should suggest the similar Cargo variable; the injected compiler instead prints the generic 'may not be available' help.
