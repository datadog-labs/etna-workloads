# Adapted injection for Just totally fully deny late-bound consts

Fix: https://github.com/rust-lang/rust/commit/3862095bd214a3ebdfb3fbaa4a13eac2ad8de331

# Rationale
1. compiler/rustc_ast_passes/src/feature_gate.rs, `check_late_bound_lifetime_defs`: removed the block that emits `ForbiddenConstParam` when `non_lifetime_binders` is on and a const param is in a `for<>` binder. Re-expresses fix hunk `@@ -162,6 +162,22 @@ impl<'a> PostExpansionVisitor<'a>` (added "FIXME(non_lifetime_binders): Const bound params are pretty broken").
2. compiler/rustc_resolve/src/late.rs, rib handling for `RibKind::Normal`: dropped `&& matches!(param.kind, GenericParamKind::Type { .. })`, so const params are again resolved as valid late-bound params. Re-expresses `@@ -2763,7 +2763,11 @@` ("Stop special-casing const params to error out here").
The resolve_bound_vars.rs hunk (emit_unless) already is equivalent to the old code in 1.99.1 (`emit_unless_delay`), left unchanged.
