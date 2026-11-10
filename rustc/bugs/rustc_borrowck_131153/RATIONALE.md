# Adapted injection for Improve duplicate derive Copy/Clone diagnostics

Fix: https://github.com/rust-lang/rust/commit/e3029abfaec4252ab0ae7010780be0094d8870e0

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, fn `report` (MirBorrowckCtxt).
Fix hunk `@@ -267,6 +268,15 @@ ... fn report` added `if self.has_ambiguous_copy(original_path.ty(..).ty) { span_delayed_bug(..); return; }`.
In 1.99.1 that check sits before the error construction; I removed the call, so bogus move errors are emitted again for types with conflicting Copy impls (pre-fix behaviour). The helper `has_ambiguous_copy` is kept with `#[allow(dead_code)]` so it still compiles (the fix's other hunks add the helper/import).
