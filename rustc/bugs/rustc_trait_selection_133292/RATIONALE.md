# Adapted injection for E0277: suggest dereferencing function arguments in more cases

Fix: https://github.com/rust-lang/rust/commit/403c8c2fd6205ca0687abde55fbe5af7b325b7d9

# Hunk: suggestions.rs, `TypeErrCtxt::suggest_dereferences`
In the `match expr.kind` computing `(is_under_ref, base_ty, span)`, the fallback arm
`_ => (None, real_ty, obligation.cause.span)` is changed to `_ => return false`.
Re-expresses the fix hunk `@@ -459,127 +458,100 @@ suggest_dereferences`, which replaced the old logic
(suggest only when the argument is an `&expr` AddrOf node, otherwise nothing) with the
new `(is_under_ref, base_ty, span)` match whose `_ => (None, real_ty, obligation.cause.span)` arm
allows dereference suggestions for non-reference arguments (e.g. `Box`/Copy values).
