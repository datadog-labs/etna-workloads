# Adapted injection for Lower fn items as ZST valtrees and delay a bug

Fix: https://github.com/rust-lang/rust/commit/f0cb746480830d585768c03f8447c0e5f9817b52

# Rationale
Only one hunk changed: `compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs`, in the const-path lowering
match arm `Res::Def(DefKind::Fn | DefKind::AssocFn, did)`.

It re-expresses fix hunk `@@ -2154,11 +2154,15 @@` (the same arm). The 1.99.1 code emitted a hard error and returned
`Const::new_error`. It now does what the fix does: `span_delayed_bug("function items cannot be used as const args")`,
then lowers the path segment's generic args and returns
`Const::new_value(tcx, ValTree::zst(tcx), Ty::new_fn_def(tcx, did, Binder::dummy(args)))`.
`Binder::dummy` and `zst(tcx)` are adaptations to the current APIs. As a result the user gets the later
"constant `fn_item` is not of type `usize`" error instead of a direct error about fn items.

The pretty.rs hunks of the fix are not touched. The FnDef printing arm already exists in 1.99.1, and the
other hunks were refactors only.
