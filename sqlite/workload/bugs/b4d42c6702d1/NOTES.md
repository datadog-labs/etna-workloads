`repro.sql` builds the tables from existsexpr-14.1 and 14.2 and runs the two EXISTS queries.
The OR-optimization on a loop created by exists-to-join coded its early-exit per OR branch instead of for the whole loop.
Clean shell: prints `match` and `20|20`. Buggy shell: prints nothing (both EXISTS queries wrongly return no rows).
