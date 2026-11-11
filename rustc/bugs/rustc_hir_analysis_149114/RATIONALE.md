# Adapted injection for Lower `hir::ConstArgKind::Struct` to a `ValTree`

Fix: https://github.com/rust-lang/rust/commit/484480412e7779d364a4d28be0f4ca6c50d9492b

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `lower_const_arg` (match on ConstArgKind).
Re-expresses fix hunk `@@ -2263,15 +2263,120 @@`: the fix replaced
`hir::ConstArgKind::Struct(..) => span_bug!(const_arg.span(), "lowering `{:?}` is not yet implemented", const_arg)`
with a call to `lower_const_arg_struct` (which builds a ValTree). I restored the span_bug arm, so struct-expression
const args are no longer lowered (ICE). `lower_const_arg_struct` is left in place (now dead code, warning only).
Other fix hunks (anon-const renames, const-param delayed bug) are already differently structured in 1.99.1 and were not touched.
