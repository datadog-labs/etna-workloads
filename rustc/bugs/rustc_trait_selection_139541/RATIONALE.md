# Adapted injection for Instantiate higher-ranked transmute goal

Fix: https://github.com/rust-lang/rust/commit/68692b7fbb674ea51c0b504ac4b8cc791311b10d

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/confirmation.rs, fn confirm_transmutability_candidate.
Re-expresses fix hunk `@@ -404,7 +404,7 @@` : `-let predicate = obligation.predicate.skip_binder();` / `+let predicate = self.infcx.enter_forall_and_leak_universe(obligation.predicate);`.
Buggy behaviour restored: skip_binder instead of instantiating the higher-ranked goal with placeholders (bound vars leak -> ICE).
The fix's first two hunks (rebind(trait_ref)/rebind(outlives)) are already in their pre-fix-equivalent form in 1.99.1 (code was refactored) and were left alone.
