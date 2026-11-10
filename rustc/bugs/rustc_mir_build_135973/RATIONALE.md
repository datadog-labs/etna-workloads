# Adapted injection for fix tail call checks wrt `#[track_caller]`

Fix: https://github.com/rust-lang/rust/commit/992e3b4f03e0bd348699337317091cc34268684b

# Rationale
All in compiler/rustc_mir_build/src/check_tail_calls.rs.
1. `check_tail_call` (track_caller block): fix hunk `@@ -131,11 +131,24 @@` replaced `caller_needs_location != callee_needs_location -> report_track_caller_mismatch` with `if caller_needs_location { report_track_caller_caller }`. Restored the old comparison of caller vs callee (`self.needs_location(ty)`).
2. `needs_location(ty)` re-added (fix hunk `@@ -149,7 +162,9 @@`, which documented "Panics if the function's instance can't be immediately resolved"): uses `Instance::expect_resolve`, so unresolved trait fns like `T::f` ICE (issue 134336).
3. `report_track_caller_mismatch` restored in place of `report_track_caller_caller` (fix hunk `@@ -292,25 +307,15 @@`), with the two old messages.
