# Adapted injection for Emit explanatory note for move errors in packed struct derives

Fix: https://github.com/rust-lang/rust/commit/4b3ece475d6e77465a30c8b53d7e1e9e861e4b79

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, fn add_move_hints (end of the `GenericArgsMismatch`-less move-out branch).
Removed the call `self.add_note_for_packed_struct_derive(err, original_path.local);`.
Re-expresses fix hunk `@@ -488,6 +488,8 @@ impl<'a, 'tcx> MirBorrowckCtxt<'a, 'tcx>` which added that call. The helper (hunk 3) stays defined but is unused, so the packed-derive note is never emitted (pre-fix behaviour).
