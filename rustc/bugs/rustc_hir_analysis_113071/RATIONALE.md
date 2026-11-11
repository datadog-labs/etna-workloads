# Adapted injection for Account for late-bound vars from parent arg-position impl trait

Fix: https://github.com/rust-lang/rust/commit/26cd5486f89d49b18af91d5c44d6f93e55261ba6

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `resolve_type_ref` tail (the "could not resolve" fallback).
Removed the loop that walks back scopes looking for `Scope::Binder { where_bound_origin: Some(PredicateOrigin::ImplTrait) }` and emits `LateBoundInApit::Type/Const`.
Re-expresses fix hunk `@@ -1446,6 +1447,50 @@` ("We may fail to resolve higher-ranked ty/const vars that are mentioned by APIT ..."). Without it, the nested APIT case reaches the `span_bug!("could not resolve ...")` (ICE) instead of a diagnostic.
The messages.ftl/errors.rs hunks already exist in 1.99.1 (diagnostics.rs); left unchanged.
