# Adapted injection for Fix up tests

Fix: https://github.com/rust-lang/rust/commit/73d49f8c697da34ee1372b51540bfb0f1ae0c712

# Rationale
compiler/rustc_hir_typeck/src/coercion.rs, `FnCtxt::coerce`: the `coerce_never` argument to `Coerce::new` is now always `true` instead of `self.tcx.expr_guaranteed_to_constitute_read_for_never(expr)`.
Re-expresses the fix's hunk `@@ -82,6 +82,10 @@ struct Coerce` (doc: "Whether we allow `NeverToAny` coercions. This is unsound if we're coercing a place expression without it counting as a read in the MIR"). The fix's other hunks are renames/comments. With the flag always true, place expressions of type `!` (e.g. `*x` with `x: *const !`) get NeverToAny without a MIR read, which is the unsound behaviour tested by uninhabited_not_read.rs.
