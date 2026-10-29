## What repro.sql does

Creates a table `t1` with an `AFTER INSERT` trigger whose body contains a
window function (`rank() OVER w1`) referencing a named window (`WINDOW w1`)
whose own partition-by list itself contains another window-function call
(`percent_rank() OVER w1`) referencing the same window name. This nested
self-reference is the minimal shape needed to recreate the historical bug.

`ALTER TABLE t1 RENAME TO t1x` then renames the table. Renaming re-parses
and re-resolves the trigger body's SQL text under `IN_RENAME_OBJECT`
processing. Walking the window definition while resolving the nested
window-function expression recurses back into the same window definition,
and without the fix this recursion is unbounded, overflowing the stack.

## What differs between the shells

- `sqlite3-clean` (with `fix.patch`'s guard, i.e. the real fixed 3.54.1):
  the `ALTER TABLE ... RENAME` succeeds, and the rewritten trigger/table SQL
  is printed normally; exit status 0.
- `sqlite3-buggy` (with `injection.patch`, i.e. the bug reintroduced): the
  `ALTER TABLE ... RENAME` recurses infinitely while resolving the window
  function during rename, overflowing the stack and crashing the process
  with SIGSEGV (exit status -11), producing no output.
