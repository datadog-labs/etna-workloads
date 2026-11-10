# Adapted injection for fix #105061, Fix unused_parens issue for higher ranked function pointers

Fix: https://github.com/rust-lang/rust/commit/7d99866bfc43f34dbdd84f4bf982c48a51b70a99

# Rationale
File compiler/rustc_lint/src/unused.rs, `UnusedParens::check_ty`, `TyKind::Paren` arm.
Current code: `ast::TyKind::FnPtr(b) => !self.with_self_ty_parens || b.generic_params.is_empty()`
(the modern equivalent of the fix's removal of `ast::TyKind::BareFn(b) if b.generic_params.len() > 0 => {}` in
hunk `@@ -1002,7 +1002,6 @@ impl EarlyLintPass for UnusedParens`; the fix made the exemption conditional / removed it).
Reinjected: `ast::TyKind::FnPtr(b) => b.generic_params.is_empty()`, i.e. parenthesized higher-ranked fn pointers are
never linted (the pre-fix exemption). The early.rs hunk (skipping where-predicates) has no 1.99.1 counterpart and is not needed.
