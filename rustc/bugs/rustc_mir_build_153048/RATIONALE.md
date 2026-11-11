# Adapted injection for Improve irrefutable let-else lint wording

Fix: https://github.com/rust-lang/rust/commit/a8d4eeef1b9817bdb464ecb91053d1a99706dd59

# Rationale
Only hunk: compiler/rustc_mir_build/src/diagnostics.rs, struct IrrefutableLetPatternsLetElse.
Re-expresses fix.diff hunk `@@ -932,13 +932,14 @@ pub(crate) struct IrrefutableLetPatternsIfLetGuard`: the fix changed the
note to "this pattern always matches, so the else clause is unreachable" and removed
`#[help("consider removing the `else` clause")]`. I restored the old note
("this pattern will always match, so the `else` clause is useless") and the help.
The else_span plumbing in check_match.rs had already been rewritten upstream (else_keyword_span / suggestion), so it was not reverted.
