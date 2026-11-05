# Rationale

## Changed hunk
- File/function: `src/src/bin/psql/tab-complete.in.c`, `psql_completion()`, the `Matches("COPY", MatchAny, "FROM|TO")` branch.
- Traces to the `fix_impl.patch` hunk in `tab-complete.c` that adds `completion_force_quote = true; /* COPY requires quoted filename */` for SQL COPY.
- The change sets `completion_force_quote = false` there. SQL COPY filename completion no longer forces quotes around the result, which is the behaviour the fix removed. `quote_if_needed` and the quoting hooks still exist but are told not to quote. A filename that needs no quoting is completed bare, and SQL COPY requires it quoted.

## Failing oracle cases
53 of 89 fail, mainly in `src/bin/psql|t/010_tab_completion.pl`. They include the filename cases ("quoted filename completion with one possibility", "quoted filename completion with multiple possibilities", "offer multiple file choices"). Many later cases also fail, including the keyword-case and `\r works` cases. I did not check why the later cases fail, so I can't say whether the filename change causes them directly or through the shared psql session. The full list is in `logs/oracle.log`.
