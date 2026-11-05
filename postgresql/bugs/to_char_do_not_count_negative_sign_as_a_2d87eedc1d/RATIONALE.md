# Rationale
File: src/backend/utils/adt/formatting.c, function DCH_to_char(). Traces to the fix.patch hunks in the same function.
The fix widened the zero-pad width by one when the value is negative, so the minus sign is not counted as a digit. I put back the fixed widths for HH12, HH24, MI, SS, MM, CC (the `i` case), YYYY/IYYY, YYY/IYY and YY/IY.
With the fixed width, `-1` prints as `-1` instead of `-01`, and negative interval or time values are padded one digit short.
I did not touch DCH_OF. The code there was restructured since the fix and now uses a separate sign character.

Failing oracle cases: src/test/regress||timestamp, src/test/regress||timestamptz
