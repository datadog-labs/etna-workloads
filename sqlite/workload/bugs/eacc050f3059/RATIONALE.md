# group_concat() returns NULL instead of '' (ticket 55746f9e65f8587)

Fix hunk (src/func.c, groupConcatStep): `if( nVal ) append` -> `if( nVal || firstTerm ) append`.
The pre-fix code skipped appending empty terms, so if every term was empty the accumulator
never allocated a buffer and finalize returned NULL.

Changes in tree/src/func.c:
1. groupConcatStep: `if( zVal ) sqlite3_str_append(...)` -> `if( nVal ) sqlite3_str_append(...)`
   (the pre-fix condition: empty terms are not appended).
2. groupConcatFinalize: today's sqlite3_result_str() turns an empty accumulator into '' on its own,
   which would mask (1). Restore the old outcome by only calling it when the accumulator has a buffer
   (`pGCC->str.zText`); otherwise no result is set, i.e. NULL, as before the fix.

Oracle: func-24.13 fails (typeof(group_concat('')) is null, expected text).
func-24.14 still passes (the two-arg separator path allocates a buffer even for empty appends).
