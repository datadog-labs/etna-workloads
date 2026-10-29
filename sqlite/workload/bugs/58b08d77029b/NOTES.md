# Reproducer notes

`repro.sql` declares a window `w1` whose `PARTITION BY` clause is itself
`OVER w1`, i.e. the window definition refers to itself, and uses an
aggregate (`geopoly_group_bbox`) that has no window-function support, so
resolving it raises a "may not be used as a window function" error.

This mirrors windowE.test case 2.1 (and related 2.2/3.x/4.x/5.x cases,
which all exercise the same resolveExprStep() path for window-function
expressions after an error has already been raised).

- **Clean shell**: reports the error
  `geopoly_group_bbox() may not be used as a window function` and exits 1.
- **Buggy shell**: segfaults (exit status -11). With the `injection.patch`
  bug, `resolveExprStep()` in `src/resolve.c` continues processing the
  self-referential window object after `pParse->nErr` has already been set
  by the "may not be used as a window function" error, instead of bailing
  out immediately (the upstream fix adds the `pParse->nErr==0` guard). This
  lets the code recurse back into the same window definition it is already
  resolving, leading to unbounded recursion and a stack overflow / crash.
