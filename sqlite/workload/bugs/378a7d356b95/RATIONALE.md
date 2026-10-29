# Rationale

Fix hunk (src/util.c): added `&& nDigit>0` to the `eType>=2 && (eType==3||eValid)` "float with extra text -> -1" return, so a lone "." is not reported as a float with trailing text.

In 3.54.1 that code was rewritten (`sqlite3AtoF`, mState bits). The equivalent spot is the `.` branch: when no digit follows the '.' and no digit was seen before (`mState==0`, i.e. nDigit==0), it returns 0 (not a number). I changed that return to `0xfffffff0 | 2`, the "float (mState bit 2) with extra text" result. That is what the pre-fix code returned for ".": eType==2 with no digits, which gave -1.

## Oracle failures
cast-7.30 (`SELECT -'.'`) and cast-7.31 (`SELECT '.'+0`) fail. Both treat '.' as a float with trailing text instead of a plain non-number.
