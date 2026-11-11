# Adapted injection for Fix two incorrect turbofish suggestions

Fix: https://github.com/rust-lang/rust/commit/d8d27ca82249555906f5deb687e44813beef0062

File: compiler/rustc_parse/src/parser/function.rs, fn parse_param_general (moved from item.rs in the fix).
Hunk 1 (fix `@@ -2960,13 +2960,30 @@`): removed the `check_trailing_angle_brackets` block that returns a dummy arg, and restored the old plain condition `if ty.is_ok() && token != Comma && token != CloseParen { ty = unexpected_any() }`.
Hunk 2 (fix `@@ -2977,6 +2994,7 @@`): removed the arm `Err(err) if this.unmatched_angle_bracket_count > 0 => return Err(err),`.
