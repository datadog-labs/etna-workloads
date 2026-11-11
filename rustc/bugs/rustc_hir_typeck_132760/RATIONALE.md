# Adapted injection for Don't suggest `.into_iter()` on iterators

Fix: https://github.com/rust-lang/rust/commit/cea82ed1626f00930845ea48e3485eae8d44b422

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `impl_into_iterator_should_be_iterator`, closure `is_iterator_predicate`.
Re-expresses fix hunk `@@ -131,15 +131,17 @@`: the fix added
`// ignore unsatisfied predicates generated from trying to auto-ref ty (#127511)` and `&& trait_pred.trait_ref.self_ty() == ty`.
I removed that self-type check, so `&impl Iterator: Iterator` (from auto-ref probing) counts as an unsatisfied Iterator predicate and `.into_iter()` is wrongly suggested.
The lifetime/closure refactor hunks are not behaviour-relevant (already present in 1.99.1).
