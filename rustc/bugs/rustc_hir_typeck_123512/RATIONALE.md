# Adapted injection for Properly downgrade inherited mutability

Fix: https://github.com/rust-lang/rust/commit/4cd87c463c2a58379b2efd45cdc92027f2965611

# Rationale
File: compiler/rustc_hir_typeck/src/pat.rs, `check_pat_ref`, `InheritedRefMatchRule::EatInner` branch (where the `&` pattern matches the real reference).

Fix hunk: `@@ -299,7 +299,11 @@ ... fix_pat` — the fix added
`if new_bm.0 == ByRef::Yes(Mutability::Mut) && mutbl == Mutability::Not { new_bm.0 = ByRef::Yes(Mutability::Not); }`
so a `&` pattern properly downgrades the inherited `ref mut` default binding mode. That code was rewritten in 1.99.1 into
`mutbl_cap = min(r_mutbl, pat_info.max_ref_mutbl.as_mutbl()); binding_mode.cap_ref_mutability(mutbl_cap)`.
Re-injection: for `&` (shared) patterns the cap now ignores `max_ref_mutbl` (only `r_mutbl`), so the inherited mutability is not properly downgraded when the pattern is `&`.
