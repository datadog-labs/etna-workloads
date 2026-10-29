# Ticket #1825 reintroduced

Changes in `tree/src/attach.c`:
- `attachFunc`: removed `if( zFile==0 ) zFile = ""; if( zName==0 ) zName = "";` (fix hunk 1, which added them).
- `detachFunc`: removed `if( zName==0 ) zName = "";` (fix hunk replacing `assert(zName)`). The existing `assert( zName )` in attachFunc's loop (and `sqlite3DbIsNamed` use) now sees NULL.

The snprintf `sizeof(zErr)` hunks are cosmetic and not reverted; the `zName &&` check is superseded by `sqlite3DbIsNamed` code.

Oracle: attach3-12.2 (`ATTACH DATABASE ? AS ?` with unbound params) aborts with `Assertion 'zName' failed` in attachFunc (NULL deref/crash in non-assert builds); later 12.x cases not reached.
