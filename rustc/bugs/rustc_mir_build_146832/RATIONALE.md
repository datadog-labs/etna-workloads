# Adapted injection for Not linting irrefutable_let_patterns on let chains inline rest of the check try fix ci errors inline in check_let

Fix: https://github.com/rust-lang/rust/commit/4f31ff893d4dd6125a445e3bda85c0fae623578c

Fix removed `check_let_chain` and the Leading/TrailingIrrefutableLetPatterns diagnostics, linting only single lets. Re-injected:

1. compiler/rustc_mir_build/src/diagnostics.rs (errors.rs in the fix diff; file renamed in 1.99.1): re-added `LeadingIrrefutableLetPatterns` and `TrailingIrrefutableLetPatterns` structs (fix hunk `@@ -874,52 +874,6 @@ pub(crate) struct UpperRangeBoundCannotBeMin`), using `#[derive(Diagnostic)]` as current code does.
2. check_match.rs, `visit_expr` LogicalOp::And arm: restored `if chain_refutabilities.iter().any(|x| x.is_some()) { self.check_let_chain(..) }` instead of `if let [Some((_, Irrefutable))] = ... { lint_single_let }` (hunk `@@ -167,9 +167,9 @@`).
3. check_match.rs: re-added `fn check_let_chain` (whole-chain, leading-prefix, trailing-suffix lints) alongside `lint_single_let` (hunk `@@ -549,74 +540,8 @@`). The check_let hunk (-430) was left as is: its single-let behaviour is equivalent.
