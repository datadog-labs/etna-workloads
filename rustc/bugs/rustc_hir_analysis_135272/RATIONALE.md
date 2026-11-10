# Adapted injection for Bless and add tests

Fix: https://github.com/rust-lang/rust/commit/6833c27090d5022457bef8dd1af3cd4c5aa9ff3b

# Rationale
The fix's tests expect `for<...>` closures to reject `_` in const (`[u32; _]`) and ambiguous (`Vec<_>`, `Foo<_>`) generic-arg positions (new tests forbid_const_infer / forbid_ambig_const_infers / forbid_ambig_type_infers; fix.diff hunks adding `ERROR: implicit types in closure signatures are forbidden when `for<...>` is present`). The fix also replaces `GenericArg::Infer`/const `_` handling with `AmbigArg` (see the `hir.rs` hunk `@@ -4637,3 +4637,6 @@` adding `mod tests` for AmbigArg casts).

Changed: `compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs`, `FindInferInClosureWithBinder::visit_infer` (inside `span_of_infer`). It now breaks only for `InferKind::Ty`, ignoring `InferKind::Const` and `InferKind::Ambig`, so the closure-binder diagnostic misses const/ambiguous infers (old behaviour, where only type `_` was found).
