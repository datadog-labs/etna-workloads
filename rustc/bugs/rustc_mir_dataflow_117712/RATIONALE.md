# Adapted injection for generator layout: ignore fake borrows

Fix: https://github.com/rust-lang/rust/commit/a42eca42df821a1d6e74a931195a00258f94bd6a

# Rationale
File: compiler/rustc_mir_dataflow/src/impls/borrowed_locals.rs, `MaybeBorrowedLocals`'s `visit_rvalue`.
Re-expresses fix hunk `@@ -91,13 +92,17 @@` : the fix changed `Rvalue::Ref(_, _, borrowed_place)` to
`Rvalue::Ref(_, BorrowKind::Mut { .. } | BorrowKind::Shared, borrowed_place)` and added
`| Rvalue::Ref(_, BorrowKind::Shallow, _)` (now `BorrowKind::Fake(_)`) to the no-op arm.
I reverted that: all Ref borrows (including fake borrows) mark the local as borrowed, so fake borrows affect coroutine layout.
(Doc-comment hunks not reproduced.)
