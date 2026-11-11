# Adapted injection for On E0277 pointing at bound in derive, suggest manual impl

Fix: https://github.com/rust-lang/rust/commit/679f38c1259d96463c5f04f175846501fbca2a15

# Rationale
Only one hunk changed: compiler/rustc_builtin_macros/src/deriving/generic/mod.rs, `TraitDef::create_derived_impl`
(generic param construction). Re-expresses fix hunk `@@ -638,27 +638,27 @@ impl<'a> TraitDef<'a>` which introduced
`let span = param.ident.span.with_ctxt(ctxt);` and used it for the additional bounds, the trait bound
(`trait_path.span = span`), the Copy bound and `cx.typaram(span, ...)`. Reverted to the old behaviour: bounds use
`self.span` (the derive macro span) and the trait path keeps its original span, so diagnostics no longer point at the type param.
The other fix hunks (hir.rs, ty/diagnostics.rs, suggestions.rs) were already refactored in 1.99.1 and left alone.
