# Rationale
Changes in src/src/bin/psql/tab-complete.in.c:

1. `COMPLETE_WITH_ENUM_VALUE` macro: always uses `Query_for_list_of_enum_values_quoted`, dropping the
   quoted/unquoted choice (fix.patch hunk 1 and the query-split hunks). Enum labels are therefore
   always offered with a leading quote, even when a quote is already before the word (readline),
   giving doubled quotes.
2. `psql_completion`: removed `rl_completion_suppress_quote = 1` after the empty non-match fallback
   (fix.patch last hunk).

Failing oracle cases: 48/89, including "offer multiple enum choices" and, because the TAP script
desyncs after the enum case, many later cases in 010_tab_completion.pl (e.g. keyword COLUMN, timezone,
completion case, load plpgsql extension). Run the oracle for the full list.
