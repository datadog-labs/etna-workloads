# Adapted injection for Check generic params after sigature for main-fn-ty

Fix: https://github.com/rust-lang/rust/commit/a7d6f42db361582645c7ee8d112d5126592177e5

# Rationale
File: compiler/rustc_hir_analysis/src/check/entry.rs, fn check_main_fn_ty.
Moved the generics / where-clause check (`MainFunctionGenericParameters` / `WhereClauseOnMain`) from after
`check_function_signature(...)` back to before the asyncness check, i.e. before the signature check.
Re-expresses fix hunks `@@ -92,24 +92,6 @@ fn check_main_fn_ty` (removal of the early generics check) and
`@@ -189,7 +167,28 @@` (re-adding it after check_function_signature, which returns early on error).
Parent behaviour: generics error is emitted first, so `fn main(_: &i32)` (late-bound region var) reports
a generic-parameters error instead of the "wrong type" signature error (issue 118772).
In 1.99.1 the function returns Result, so the early `return Err` is preserved in the moved block.
