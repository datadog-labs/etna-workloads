Compiles a float literal ending in '.' that falls back to f32; the lint suggestion should be `0_f32` but the injected compiler suggests `0._f32` (invalid code).
