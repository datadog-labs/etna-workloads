# Adapted injection for Fix a subtle regression

Fix: https://github.com/rust-lang/rust/commit/d46ff6415c033ccfebac3d2a757908611a67d324

# Rationale
File `compiler/rustc_mir_build/src/builder/matches/buckets.rs`, fn `sort_candidate`, arm `(TestKind::SwitchInt, TestableCase::Constant{..})`.
Fix hunk: `@@ -510,9 +510,30 @@ ... (TestKind::SwitchInt, &TestCase::Constant { value })` added `is_covering_range`/`is_conflicting_candidate` and refused to add a success case (`fully_matched=false; None`) if a range already sorted into the Failure bucket covers the value.
Reintroduced bug: removed that check, so the arm unconditionally does `fully_matched = true; Some(TestBranch::Constant(value))`. The `as_range` helper (fix hunk in mod.rs) is left in place, now unused (dead-code warning).
