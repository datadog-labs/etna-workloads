Shows that for `&str::from("value")` / `&mut S::foo()` the injected compiler additionally suggests borrowing again (`&<&str>::from`), changing the E0277 diagnostics; the clean compiler does not.
