# Rationale

Fix: `page_count` / `quick_check` pragmas failed when their names were capitalized, because the code tested the raw first byte of `zLeft`. The fix made the test case-insensitive. In 3.54.1 the same tests use `sqlite3Tolower(zLeft[0])`.

## Hunks changed (tree/src/pragma.c)
1. `PragTyp_PAGE_COUNT`: `sqlite3Tolower(zLeft[0])=='p'` -> `zLeft[0]=='p'`. This reverses the fix's first hunk. `PRAGMA PAGE_COUNT` now takes the `max_page_count` branch, so it returns the max page count instead of the page count.
2. `PragTyp_INTEGRITY_CHECK`: `isQuick = (sqlite3Tolower(zLeft[0])=='q')` -> `(zLeft[0]=='q')`. This reverses the fix's second hunk. `PRAGMA QUICK_CHECK` is now treated as a full integrity_check.

## Oracle failures
pragma-14.2uc, pragma-14.3uc and pragma-14.6uc fail: `PAGE_COUNT` returns the max page count instead of 2, 3 and 5. pragma-3.8.2 (`QUICK_CHECK`) still returns `ok`, because a full check also gives `ok` on that database. It is not in the failing list.
