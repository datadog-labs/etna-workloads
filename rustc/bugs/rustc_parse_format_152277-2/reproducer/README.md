Proc macro respans a println!(r"{}") raw format string onto a multi-byte literal; the injected compiler skips validating the snippet and ICEs (exit 101) instead of a normal error (exit 1).
