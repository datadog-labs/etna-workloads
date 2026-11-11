# Adapted injection for Explain why a given pattern is considered unreachable

Fix: https://github.com/rust-lang/rust/commit/64ac2b80822c33d69e6e61ea1eaf8a043bc35aad

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn `report_unreachable_pattern`.
The fix's hunk `@@ -910,26 +910,52 @@ fn report_irrefutable_let_patterns` added the explanation match
(`[covering_pat] => lint.covered_by_one = Some(...)` and `covering_pats => ... covered_by_many`).
Before the fix only the catch-all label (`catchall`) existed. I re-expressed that by making the
single non-catchall case and the many-patterns case produce no explanation labels
(`[_covering_pat] => {}`, `covering_pats if false`, fallthrough `_ => {}`). The catchall and empty cases are unchanged.
