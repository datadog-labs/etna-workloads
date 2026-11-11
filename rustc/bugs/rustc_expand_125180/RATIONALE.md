# Adapted injection for Improve error message: missing `;` in macro_rules

Fix: https://github.com/rust-lang/rust/commit/c2be1342b7f9c2c32df01426f066c3a00a39e398

# Rationale
Fix: `@@ -447,16 +452,14 @@ compile_declarative_macro` / `parse_failure_msg(&token, track.get_expected_token())` — the fix made a missing `;` between macro_rules arms report "expected `;`, found `(`" using the expected separator token instead of the generic "no rules expected the token".

1.99.1 no longer has FailureForwarder/Tracker expected-token plumbing; macro definitions are parsed with `Parser` in `compile_declarative_macro` (compiler/rustc_expand/src/mbe/macro_rules.rs), and `p.expect(exp_sep)` produces the "expected `;`, found `(`" error. I replaced it with `p.eat(exp_sep)` and, on failure, a generic "no rules expected <token>" error (the pre-fix behaviour: no expected token passed to the message). Also imported `token_descr`.
