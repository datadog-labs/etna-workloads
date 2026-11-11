# Adapted injection for If the moved value is a mut reference, it is used in a generic function and it's type is a generic param, it can be reborrowed to avoid moving. for example:

Fix: https://github.com/rust-lang/rust/commit/4821b84b92a2f2bbed06191cab5cc44693e0652b

# Rationale
One hunk: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, `suggest_ref_or_clone`.
Removed the block (the `if let ty::Ref(_, _, Mut) = ty.kind() && arg_param.is_some() { *has_suggest_reborrow = true; self.suggest_reborrow(err, expr.span, moved_place); return; }`) that reborrows a `&mut` moved into a generic fn parameter.
Re-expresses fix hunk `@@ -435,20 +436,44 @@ ... suggest_ref_or_clone` ("If the moved value is a mut reference, it is used in a generic function and it's type is a generic param, it can be reborrowed to avoid moving"). Without it, the clone/borrow suggestions come first and the reborrow suggestion is lost (issue 127285). The `has_suggest_reborrow` plumbing stays, so it is now never set (unused-variable warning only).
