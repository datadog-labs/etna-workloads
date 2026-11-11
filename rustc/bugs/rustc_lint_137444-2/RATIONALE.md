# Adapted injection for Improve behavior of IF_LET_RESCOPE around temporaries and place expressions

Fix: https://github.com/rust-lang/rust/commit/bab03bf1768fea8512ece42dea6d66f6f4743145

# Rationale
File: compiler/rustc_lint/src/if_let_rescope.rs, fn `FindSignificantDropper::check_promoted_temp_with_drop`.
Removed the `if expr.is_place_expr(|base| ... Adjust::Deref ...) { return ControlFlow::Continue(()); }` early return.
Re-expresses fix hunk `@@ -363,96 +364,81 @@ enum SingleArmMatchBegin`, which added
`if !expr.is_place_expr(|base| ... Adjust::Deref(_)) && ...has_significant_drop` (promoted temps must not be place exprs).
Without it, place expressions (`drop.as_ref()` autoref, `tup_place.1`) are treated as temporaries -> false-positive lint.
