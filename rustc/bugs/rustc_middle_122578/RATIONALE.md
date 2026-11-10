# Adapted injection for Invoke decorate when error level is beyond warning, including error

Fix: https://github.com/rust-lang/rust/commit/60de7554de5537bfaf359905ec2c1fad60f9cfbd

# Rationale
File: compiler/rustc_middle/src/lint.rs, fn emit_lint_base_impl (the `skip` computation before `decorate`).

Fix hunk `@@ -398,14 +398,23 @@ pub fn lint_level(`: it changed the guard from
`matches!(err_level, ForceWarning(_)) || can_emit_warnings()` to
`matches!(err_level, ELevel::ForceWarning(_) | ELevel::Error) || can_emit_warnings()`,
so that `decorate` also runs for Error-level lints.

In 1.99.1 the guard is expressed as `skip = err_level == Warning && !can_emit_warnings()`.
I changed it to `skip = !matches!(err_level, ForceWarning) && !can_emit_warnings()`.
That is the pre-fix behaviour: `decorate` is skipped for Error lints when `-A warnings` is set,
so the diagnostic loses its decoration.
