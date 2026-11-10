# Adapted injection for Emit fatal on defaults for generic params in binders if with nested defs

Fix: https://github.com/rust-lang/rust/commit/1fca34d15da42d3ef69bd1f6179477cd474c0591

# Rationale
File compiler/rustc_ast_lowering/src/lib.rs, fn lower_generic_param (GenericParamKind::Const arm).
Re-expresses fix hunk `@@ -2220,14 +2220,19 @@`: removed the `WillCreateDefIdsVisitor ... is_break() => emit_fatal(err)` branch,
restoring the old `.filter(|_| ...Binder => { emit_err(GenericParamDefaultInBinder); false })`, so a const default
containing nested defs (e.g. `assert!(u)`) in a `for<>` binder is non-fatal and lowering ICEs/crashes (#123629).
