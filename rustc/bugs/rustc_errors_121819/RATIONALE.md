# Adapted injection for Handle stashing of delayed bugs.

Fix: https://github.com/rust-lang/rust/commit/44f0043e82fb2d3156434797f2e638cb61b07ce9

# Rationale
compiler/rustc_errors/src/lib.rs, `DiagCtxt::stash_diagnostic`: removed the `DelayedBug => return self.inner.borrow_mut().emit_diagnostic(...)` arm and made `DelayedBug` fall into the `Bug | Fatal` arm (span_bug "invalid level in stash_diagnostic").
Re-expresses fix hunk `@@ -719,26 +720,39 @@ impl DiagCtxt` (`+ DelayedBug => return self.inner.borrow_mut().emit_diagnostic(diag)`), restoring the pre-fix behaviour where stashing a delayed bug (downgraded error) ICEs.
The lint.rs hunk does not apply: that file moved/no longer has the callsite workaround.
