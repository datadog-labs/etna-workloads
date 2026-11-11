# Adapted injection for fixes panic error

Fix: https://github.com/rust-lang/rust/commit/9747a2c3efc231b064c2d9eb3e0cf23718a7d1b9

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, in the move-error clone suggestion code (`report_use_of_moved_or_uninitialized`).
Re-expresses the fix hunk `@@ -456,10 +456,15 @@`, which replaced `inputs()[pos + offset].kind()` with `inputs().get(pos + offset)` followed by `let ty::Param(_) = arg.kind()`.
The injected bug goes back to direct indexing, `sig.inputs()[pos + offset]`. For a variadic C fn with more args than declared inputs, this panics with index out of bounds.
