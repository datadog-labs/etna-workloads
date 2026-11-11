# Adapted injection for Show note for type ascription interpreted as a constant pattern, not a new variable

Fix: https://github.com/rust-lang/rust/commit/55b4549602d2f1105aedd7a1357a62db4f128167

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn `is_const_pat_that_looks_like_binding`
(used by `check_binding_is_irrefutable`).
Fix hunk `@@ -443,7 +443,12 @@ ... check_binding_is_irrefutable` extended the check `if let PatKind::Constant {..}` to also accept
`PatKind::AscribeUserType { subpattern: Constant, .. }`. In 1.99.1 ascriptions live in `pat.extra.ascriptions` and the
const check uses `extra.expanded_const`; I re-introduced the bug by rejecting patterns that carry ascriptions
(`let x: i32 = 3`), so the "interpreted as a constant pattern" note/suggestion is lost for them.
