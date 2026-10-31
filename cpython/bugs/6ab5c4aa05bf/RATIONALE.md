# Rationale

## Lib/_pyrepl/utils.py, `disp_str`, non-printing ("C" category) branch
Reverses the fix hunk in `Lib/_pyrepl/reader.py::disp_str` that changed
`b.extend([0] * (len(c) - 1))` to `b.append(len(c))`: the cell for a
non-printing character is given its escaped display width (`\uXXXX`) instead
of 0. In v3.15.2 this logic lives in `utils.disp_str` (`width = len(text)`);
restoring the pre-fix behaviour is `width = 0`, so the character's on-screen
width is lost and coordinate/position conversion (`Layout.xy_to_pos`) drifts.

The second fix hunk (`j += 1` in `setpos_from_xy`, an infinite-loop guard) has
no counterpart: `xy_to_pos` now iterates with `enumerate` and always advances.

## Oracle failure
`test_setpos_from_xy_for_non_printing_char`: `setpos_from_xy(8, 0)` gives
pos 9 instead of 7. The other 32 cases pass.
