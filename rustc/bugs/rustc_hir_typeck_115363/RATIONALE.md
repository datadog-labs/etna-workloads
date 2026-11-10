# Adapted injection for Don't suggest adding parentheses to call an inaccessible method.

Fix: https://github.com/rust-lang/rust/commit/7b837e075a335d482c583b574ebaf5006738655e

Fix hunk: expr.rs `@@ -2314,7 +2314,7 @@` — `true` -> `false, // don't mention or suggest non-accessible methods` (an "allow private methods" flag to method lookup). In 1.99.1 the flag no longer exists, so it is re-expressed in two places so that inaccessible methods count as existing again:
1. compiler/rustc_hir_typeck/src/method/mod.rs `method_exists_for_diagnostic`: `Err(PrivateMatch(..)) => false` -> `true`.
2. compiler/rustc_hir_typeck/src/method/probe.rs `ProbeContext::pick`: in the `is_suggestion` early-return, return `PrivateMatch` if a private candidate was found (instead of always NoMatch). Without this, (1) is never reached for diagnostic probes.
Effect: `f.method` on a private method gives E0615 instead of E0609.
