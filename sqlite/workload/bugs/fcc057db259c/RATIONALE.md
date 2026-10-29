# Rationale

## Hunk changed
`src/select.c`, `convertCompoundSelectToSubquery()`: removed
`#ifndef SQLITE_OMIT_WINDOWFUNC  p->pWinDefn = 0;  #endif` after `p->pWith = 0;`.
This reverses the fix's sole implementation hunk (same lines, same location;
only the function has been shifted/renamed-cast in 3.54.1). Without it, the
original Select `p` keeps pWinDefn, which was also moved/shared into the new
subquery `pNew` (via the struct copy), so both Selects free the window
definition list: a double-free.

## Oracle failures
window1-35.1 (`VALUES(1) INTERSECT SELECT * WINDOW f AS () ORDER BY ...`) crashes
the testfixture (double free), so the run is incomplete; 35.1 onward and all later
cases are reported failing. 35.0 still passes.
