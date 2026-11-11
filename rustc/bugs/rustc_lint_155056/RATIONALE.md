# Adapted injection for Revert #152369 because of multiple regressions

Fix: https://github.com/rust-lang/rust/commit/65745a1b95ece068a127b2cd009d2c0bd4a9f65d

# Rationale
Tree 1.99.1 already contains the pre-#152369 lint-level code (levels.rs emits MalformedAttribute itself),
so the full revert direction cannot be re-expressed cheaply. I re-expressed one narrow aspect of #152369.

## compiler/rustc_lint/src/levels.rs, `LintLevelsBuilder::add`
The four `sess.dcx().emit_err(MalformedAttribute { .. })` calls (bad reason, bad argument, list argument,
non-word lint item) are now wrapped in `if self.lint_added_lints { .. }`. This re-expresses the fix hunk
`@@ -670,102 +638,297 @@ ... fn add(` which re-adds those `+ sess.dcx().emit_err(MalformedAttribute {...})` calls
to the level builder; in the buggy parent, malformed lint attrs were reported by the attribute parser
(`rustc_attr_parsing/src/attributes/lint.rs`) and the builder did not report them on every pass.
Effect: E0452 is emitted fewer times than the 6 the fix's E0452 test expects.
