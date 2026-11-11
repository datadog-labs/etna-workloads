# Adapted injection for const_mut_refs: allow mutable refs to statics

Fix: https://github.com/rust-lang/rust/commit/340f8aac7e2da164134338986b46fb4a26fe185b

# Rationale
One hunk: compiler/rustc_const_eval/src/check_consts/check.rs, `Checker::place_may_escape` (the 1.99.1 refactor of `check_mut_borrow` plus the shared-borrow cell check).
Changed `place.is_indirect() || self.local_is_transient(place.local)` back to `self.local_is_transient(place.local)`.
Re-expresses fix hunks `@@ -355,10 +355,19 @@ fn check_mut_borrow` (`if place.is_indirect() || self.local_has_storage_dead(place.local)`, previously only `local_has_storage_dead(local)`) and `@@ -478,7 +492,14 @@` (`if borrowed_place_has_mut_interior && !place.is_indirect()`): indirect places (raw ptrs / refs to statics) are again treated as possibly escaping borrows. The qualifs.rs `deref_structural` hunks are already equivalent in 1.99.1 and unchanged.
