# Adapted injection for self type param infer, avoid ICE

Fix: https://github.com/rust-lang/rust/commit/19d46b690a8dddcb19e4919c19939844c4441594

# Rationale

Upstream fix (hunk `@@ -163,7 +163,7 @@ fn fmt_printer`, need_type_info.rs): `-    && !var_origin.span.from_expansion()` /
`+    && name != kw::SelfUpper && !var_origin.span.from_expansion()` -- the name resolver for the type printer must
not treat the inference var for the trait's synthetic `Self` param as a named type parameter (its def_id is the trait,
so `generics.param_def_id_to_index(..).unwrap()` panics -> ICE). The adjust_fulfillment_errors.rs hunks are only import refactors (nothing to re-inject).

## Hunk 1: compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs
- `fmt_printer` (ty_getter) and `extract_inference_diagnostics_data`: in 1.99.1 the Self guard is
  `&& infcx.tcx.def_kind(def_id) == DefKind::TyParam` (Self has the trait's def-id). Removed it in both places,
  re-expressing removal of the `name != kw::SelfUpper` guard. Printer now unwraps `param_def_id_to_index` for the trait def id -> ICE.

## Hunk 2: compiler/rustc_hir_typeck/src/expr.rs, `check_expr_tuple`
- Not a fix hunk itself: an adaptation. In 1.99.1 tuple elements without an expectation get a fresh `next_ty_var`, so
  the printed var is that fresh var (no param origin) and the Self var is never printed, hiding the bug. I restored the
  older behaviour (element type = `check_expr_with_expectation(e, NoExpectation)`), so the tuple contains the
  Self infer var directly and the printer sees it, as at the fix's parent commit.
