# Adapted injection for Fix unused_parens for pinned reference patterns

Fix: https://github.com/rust-lang/rust/commit/ffe1dba2fb6e6caa5d556e36a56c26461285a334

All in compiler/rustc_lint/src/unused.rs; the fix is reversed by hand since 1.99.1's context differs.
1. `UnusedParens::check_unused_parens_pat` (fix hunks `@@ -636,7` and `@@ -649,8 +649,16`): restored `PatKind::Ident(BindingMode::MUT, ..) if avoid_mut`, and removed the `PatKind::Ref(_, Pinnedness::Pinned, _) | Ident(ByRef::Yes(Pinned..))` `!pin_ergonomics` early-return. Pinned patterns now get linted without the feature gate.
2. `EarlyLintPass::check_pat` for `UnusedParens` (fix hunks `@@ -756,8` and `@@ -789,11`): restored `Ref(p, _, m) => check_unused_parens_pat(cx, p, true, *m == Mutability::Not, keep_space)`. This drops the pinnedness check and the `Ref(..) => {}` arm, and removes the `Pinnedness` import.
