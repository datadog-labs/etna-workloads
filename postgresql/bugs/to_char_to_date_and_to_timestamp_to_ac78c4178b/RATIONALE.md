# Rationale

## src/backend/utils/adt/formatting.c, DCH_to_char(), case DCH_CC
Traces to the first hunk of fix.patch (the `DCH_CC` hunk in `DCH_to_char`).
The fix added a branch for non-positive years: `i = tm->tm_year / 100 - 1`
(century 6BC == 600BC..501BC). I reverted to the pre-fix formula
`i = (tm->tm_year - 1) / 100 + 1` for every non-interval year.
For BC years (tm_year <= 0) this gives the wrong century, so to_char() no
longer formats BC centuries like AD ones.

Only this hunk is reverted. The to_date()/to_timestamp() hunks are untouched.

## Failing oracle cases
Expected to fail (not yet confirmed; the oracle run was still in progress):
- src/test/regress||timestamp
- src/test/regress||timestamptz
