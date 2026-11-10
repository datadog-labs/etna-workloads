# Adapted injection for Add note when matching on nested non-exhaustive enums

Fix: https://github.com/rust-lang/rust/commit/43dd8613a308745a9f75690bb5365f8b8ca05926

# Rationale
One hunk: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, `report_non_exhaustive_match`.
Removed the branch `else if cx.is_foreign_non_exhaustive_enum(ty) { err.note("`{ty}` is marked as non-exhaustive, ...") }` in the special_tys loop.
This re-expresses the fix hunk `@@ -750,6 +743,8 @@ fn non_exhaustive_match` which added `} else if cx.is_foreign_non_exhaustive_enum(ty) { err.note(format!("`{ty}` is marked as non-exhaustive")); }`. Without it, nested non-exhaustive enums (e.g. `Option<NonExhaustiveEnum>`) get no note, as before the fix.
The usefulness.rs hunks (Witness NonExhaustive) were already upstream-restructured and are not reproduced.
