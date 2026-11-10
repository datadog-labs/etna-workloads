# Adapted injection for Make E0284 generic argument suggestions more explicit

Fix: https://github.com/rust-lang/rust/commit/b1786813dfd2016f0f4ecac23f0b43b24e075547

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs, fn that builds `SourceKindSubdiag::Generic` for `InferSourceKind::GenericArg`.
I removed the `else if generic_args.len() == 1 && used_fallback { match param.kind {GenericTypeSuggestion / ConstGenericSuggestion ...} }` branch, so a single generic arg always uses the generic `GenericSuggestion` ("consider specifying the generic argument", `::<T>`).
This re-expresses the fix hunk `@@ -648,11 +653,31 @@ ... if !have_turbofish {` which added `if generic_args.len() == 1 && used_fallback { match param.kind {...GenericTypeSuggestion/ConstGenericSuggestion} } else { GenericSuggestion }`.
The enum variants and ftl messages are left in place (the errors.rs hunk), now unused (warning only).
