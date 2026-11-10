# Adapted injection for Delegation: fix ICE on late diagnostics

Fix: https://github.com/rust-lang/rust/commit/040791a9c59d2f604060efb75c81f685ceb5f9db

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn lookup_assoc_candidate (Delegation arm of the AssocSuggestion match).
Fix hunk `@@ -2041,8 +2041,11 @@` replaced `self.r.delegation_fn_sigs[&local_def_id(..)].has_self` with `.get(..).map_or(false, |sig| sig.has_self)`.
In 1.99.1 the guard was `owners.get(..).and_then(|o| delegation_fn_sigs.get(&o.def_id)).is_some_and(|sig| sig.has_self)`; I reverted it to direct indexing `delegation_fn_sigs[&owners[&assoc_item.id].def_id].has_self`, which panics when the delegation failed to resolve and has no sig (the ICE).
