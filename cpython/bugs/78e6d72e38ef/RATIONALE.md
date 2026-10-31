# Rationale

Fix: bpo-43950 added `_display_width` so traceback caret/anchor lines account for
double-width (wide/emoji) characters instead of counting code points.

In v3.15.2 `_display_width` (Lib/traceback.py) still exists, but computes width via `_wlen`.
I reverted it to the pre-fix behaviour: width == character count (`len(line)` / `len(line[:offset])`).
This reverses the fix hunks that introduced `dp_start_offset`/`dp_end_offset` and the
`dp_left_end_offset`/`dp_right_start_offset` computations (all of which route through `_display_width`
today), so caret positions and lengths are code-point based again.

Failing oracle cases: the wide-character tests (e.g. `test_caret_wide_char`, wide/emoji
term-highlight tests) and the colorized traceback tests now produce carets with the wrong offset/length
(e.g. `15 != 21`). Note that other tests in the run also error; I did not investigate whether those are
pre-existing.
