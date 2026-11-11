# Adapted injection for Pretty-print always-const trait predicates correctly

Fix: https://github.com/rust-lang/rust/commit/01ac44a664f575f209d2f507b38b6497162bc6e2

# Rationale
File: compiler/rustc_middle/src/ty/print/pretty.rs, fn `pretty_print_bound_constness` (the 1.99.1 successor of the helper added by fix hunk `@@ -1697,6 +1697,25 @@`).
The fix made always-const bounds print `const ` (`if arg == consts.false_ { p!("const ") }`) instead of `~const ` (the old behaviour printed every non-true bound as maybe-const).
Re-injection: `BoundConstness::Const` now prints the maybe-const form `[const] ` (the modern spelling of `~const`) instead of `const `. This corresponds to the TraitPredPrintModifiersAndPath / TraitPredicate hunks (@@ -2866 / @@ -2905), which used to print the maybe-const marker for all bounds.
