# Adapted injection for Fix ICE in next-solver dyn-compatibility check

Fix: https://github.com/rust-lang/rust/commit/89a4742773beb36a52ce4876aadb151e0fc5b8e1

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, fn `receiver_is_dispatchable`.

Fix hunk: `@@ -630,6 +633,10 @@ fn receiver_is_dispatchable` adds
`if receiver_ty.references_error() { return false; }` (undispatchable instead of asking the solver).

On 1.99.1 the guard exists, but simply deleting it does not fail the test: the solver no longer reports success for these goals, so the result is the same. To bring back the buggy outcome described by the fix ("treated error-containing dispatchability goals as proven, misclassified the trait as dyn compatible"), the guard now returns `true`. The trait is then wrongly considered dyn compatible, and object-method confirmation ICEs at rustc_hir_typeck/src/method/confirm.rs:401.
