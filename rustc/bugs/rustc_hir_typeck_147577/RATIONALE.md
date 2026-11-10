# Adapted injection for Improve error message for ambiguous numeric types in closure parameters

Fix: https://github.com/rust-lang/rust/commit/0eaa3366f904e9fde3bd3ada9d2642f23140577d

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `report_failed_method_call_on_numerical_infer_var`.
Removed the match arm `(FileName::Real(_), Node::Pat(pat)) if ... PatKind::Ref(..)` (the 1.99.1 form, which also handles nested/&mut refs) that labels "you must specify a type for this binding" and suggests `: &i32` on the pattern.
Re-expresses fix.diff hunk `@@ -2568,6 +2568,22 @@` which added exactly this arm (comment "For closure parameters with reference patterns (e.g., |&v|)"). Without it, `|&v|` falls to the `_ =>` arm, giving the plain label and no suggestion.
