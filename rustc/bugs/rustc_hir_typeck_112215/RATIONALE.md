# Adapted injection for only suppress coercion error if type is definitely unsized

Fix: https://github.com/rust-lang/rust/commit/9f70efb31aa9345e07b547b3d4f63a1e08b53c49

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn `is_return_ty_definitely_unsized`.

Fix hunk `@@ -1896,15 +1895,24 @@` replaced `is_return_ty_unsized`, which was true only when the declared return type is syntactically `dyn Trait`, with an obligation check `!predicate_may_hold(ret_ty: Sized)`. That check respects `dyn Trait: Sized` where clauses.
I restored the old behaviour: the body is now `matches!(sig.output().kind(), ty::Dynamic(..))`. This is true for any `dyn` return type, even when a `dyn Trait: Sized` where clause exists, so the coercion error is wrongly suppressed with `emit_unless_delay`.
The two call-site hunks (`@@ -1595` and `@@ -1614`) already call the new function name in 1.99.1, so they needed no change. The old code used `blk_id`/`parent_id`, and the new name is kept for a minimal diff.
