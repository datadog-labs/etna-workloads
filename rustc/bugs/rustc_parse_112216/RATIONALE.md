# Adapted injection for Support float-like tuple indices in offset_of!()

Fix: https://github.com/rust-lang/rust/commit/1b90f5efaf46073a7da509a895a0688e1c6300c3

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, `parse_floating_field_access`, the `DestructuredFloat::MiddleDot` arm.

Fix hunk (`@@ -1852 ...` in expr.rs, `parse_expr_offset_of`) added a closure that splits a Float token such as `1.2` with `break_up_float` into `thin_vec![Ident(symbol1), Ident(symbol2)]` (the `MiddleDot` case). In 1.99.1 that logic lives in `parse_floating_field_access`. I reverted the `MiddleDot` case to the pre-fix behaviour: the float token is not split, and one ident holding the whole text (e.g. `0.1`) is produced.
