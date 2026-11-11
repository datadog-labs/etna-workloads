# Adapted injection for diagnostics: don't suggest `#[derive]` if impl already exists

Fix: https://github.com/rust-lang/rust/commit/11ae531ac82fd502a6de59e7508a4546960cbee4

# Rationale

## Hunk 1: compiler/rustc_hir_typeck/src/method/suggest.rs, `consider_suggesting_derives_for_ty`
Removed the `non_blanket_impls_for_ty(...)` check (and the now-unused `trait_def_id` local) that returns
`None` when a manual impl for the ADT already exists. Re-expresses the fix hunk
`@@ -3281,6 +3281,63 @@` (adds "We need to check if there is already a manual implementation of the trait
for this specific ADT to avoid suggesting `#[derive(..)]`"). Pre-fix code had no such check.

## Hunk 2: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, clone-instead note (single-error case)
Removed `suggest_derive = false;` after `diag.help(manually_impl)`. Release 1.99.1 added this guard
that independently suppresses the derive suggestion in the issue-146515 scenario (a `#[derive(Clone)]`
whose implicit `T: Clone` bound fails), masking the bug; at the fix's parent commit that guard didn't exist,
so the derive suggestion for an already-derived `Clone` was emitted. Needed so the effect of hunk 1 is observable.
