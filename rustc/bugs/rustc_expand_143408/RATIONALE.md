# Adapted injection for mbe: Gracefully handle macro rules that end after `=>`

Fix: https://github.com/rust-lang/rust/commit/0403990000438742065e54c4cae9bb1afb0e6038

# Rationale
File compiler/rustc_expand/src/mbe/macro_rules.rs, fn compile_declarative_macro: removed the
`if let Some(guar) = check_no_eof(sess, &p, "expected right-hand side of macro rule") { return dummy_syn_ext(guar); }`
after `p.expect(exp!(FatArrow))`. This is the 1.99.1 form of the fix hunk
`@@ -411,6 +411,15 @@ pub fn compile_declarative_macro(` which added `if p.token == token::Eof { ... "macro definition ended unexpectedly" ... }`
before `p.parse_token_tree()`. Without it, a macro ending after `=>` is no longer gracefully diagnosed.
