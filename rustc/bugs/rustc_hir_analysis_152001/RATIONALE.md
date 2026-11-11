# Adapted injection for mGCA: Validate const literal against expected type

Fix: https://github.com/rust-lang/rust/commit/8af02e230aac276d7eaa538729abca8618f02225

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `try_lower_anon_const_lit`.

Re-expresses the fix hunk `@@ -2833,11 +2842,15 @@ impl<'tcx> dyn HirTyLowerer<'tcx> + '_`: the fix replaced
`.filter(|l| !l.ty.has_aliases()).map(|l| tcx.at(expr.span).lit_to_const(l))` with
`lit_input.and_then(|l| if const_lit_matches_ty(tcx, &l.lit, l.ty, l.neg) { lit_to_const(l)... } else { None })`.
I restored the parent behaviour: only filter on alias types and do not validate the literal against the expected type,
so mismatched literals (e.g. a byte string for a non-u8 array, a negative literal for an unsigned type) are lowered directly
as values of the wrong type instead of falling back to the anon-const path that reports a type mismatch.
The `const_lit_matches_ty` import is now unused (a warning only). Other fix hunks (query return type etc.) are already
present in 1.99.1 and left untouched.
