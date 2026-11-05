# Rationale

File: src/backend/commands/copy.c, function ProcessCopyOptions (all hunks trace to fix_impl.patch's three hunks).

- Removed the `freeze_specified` / `header_specified` locals (hunk 1).
- "freeze" branch: duplicate check goes back to `if (opts_out->freeze)` instead of a specified-flag (hunk 2).
  `FREEZE true, FREEZE false` is no longer detected, and `FREEZE false, FREEZE true` is accepted.
- "header" branch: duplicate check goes back to `if (opts_out->header_line != COPY_HEADER_FALSE)` (hunk 3; header_line is now an enum, not a bool).
  A repeated HEADER false/true is not detected as redundant.

Oracle case expected to fail: src/test/regress||copy2
