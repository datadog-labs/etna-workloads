# Adapted injection for Check normalized call signature for WF in mir typeck

Fix: https://github.com/rust-lang/rust/commit/2b4a2b95dd1a6b85678537332045d122afda682f

# Hunk: compiler/rustc_borrowck/src/type_check/mod.rs, check_terminator (Call arm)
Removed the `if sig != unnormalized_sig { self.prove_clauses(WellFormed for sig.inputs_and_output) }` block
after deep normalization of the call signature. Re-expresses fix hunk `@@ -1472,7 +1472,23 @@` which added
`// HACK(#114936): WF(sig) does not imply WF(normalized(sig))` and the second prove_predicates on the normalized sig.
Other fix hunks were renames only.
