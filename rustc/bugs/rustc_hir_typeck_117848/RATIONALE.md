# Adapted injection for Don't expect a rcvr in print_disambiguation_help

Fix: https://github.com/rust-lang/rust/commit/99664b0bbf0ef05ae2b004017c8da63a3ffbdbe9

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn print_disambiguation_help.
Fix hunk `@@ -3264,8 +3264,12 @@ fn print_disambiguation_help` replaced `.inputs()[0].ref_mutability()` with `.inputs().get(0).and_then(|ty| ty.ref_mutability())`.
In 1.99.1 this is `first_input = ....inputs().get(0)`; I restored the unchecked index `Some(&....inputs()[0])`, so an associated fn with no params (no receiver) ICEs with index out of bounds.
