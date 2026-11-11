# Adapted injection for Add suggestions for using `#[export_name]` instead of `#[link_name]` on statics

Fix: https://github.com/rust-lang/rust/commit/8b1803ad5db682b5e7d710a575bc5ba40d9baace

# Rationale
One hunk: compiler/rustc_attr_parsing/src/target_checking.rs, `target_checking_help`.
Removed the `[sym::link_name] if cx.target == Target::Static => Some(InvalidTargetHelp::UseExportName{..})` arm
(and the then-unused `Safety` import). This re-expresses fix hunk `@@ -187,6 +187,18 @@` in target_checking.rs,
which added the `[sym::link_name] if cx.target == Target::Static && matches!(cx.attr_safety, ...)` arm producing
`InvalidTargetHelp::UseExportName`. Without it, no `did you mean to use #[export_name]?` suggestion is emitted.
(In 1.99.1 the enum variant lives in diagnostics.rs and is left in place; it only causes a dead-code warning.)
