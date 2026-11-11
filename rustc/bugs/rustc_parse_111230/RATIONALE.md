# Adapted injection for add hint for =< as <=

Fix: https://github.com/rust-lang/rust/commit/a183ac6f90dc43a550a8afa5c01fdc797cf3d1d4

# Rationale
File compiler/rustc_parse/src/parser/expr.rs, fn parse_expr_path_start.
Fix hunk `@@ -1448,8 +1448,19 @@ fn parse_expr_path_start` added `maybe_eq_tok` and a `.map_err` on `parse_qpath` that adds a "did you mean `<=`" suggestion when `=` and `<` are adjacent. Re-injected bug: removed that (1.99.1 form of it), restoring plain `self.parse_qpath(PathStyle::Expr)?`.
