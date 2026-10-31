# Rationale

The fix made `Reader.pos2xy` tolerate an empty `screeninfo` (terminal resized to 0 columns).
In v3.15.2 that logic lives in `LayoutMap.pos_to_xy` (Lib/_pyrepl/layout.py); `pos2xy` now delegates to it.

Change: removed the `if not self.rows: return 0, 0` guard from `LayoutMap.pos_to_xy`.
This reverses the fix's `and len(self.screeninfo) > 0` check (with empty rows the old code fell through to `self.screeninfo[-1]`; now it falls through to `self.rows[-1]`), so a zero-width layout raises IndexError again.
`xy_to_pos` is untouched, since the fix did not cover it.

Failing oracle cases: `test_pos2xy_with_no_columns` fails with IndexError.
A second test in test_reader also errors via the same path (`test_prepare_with_zero_width_does_not_crash`, a zero-width resize case).
