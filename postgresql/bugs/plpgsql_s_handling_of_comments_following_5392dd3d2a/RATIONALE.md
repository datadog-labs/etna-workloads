# Rationale

Changed: src/pl/plpgsql/src/pl_gram.y, function read_sql_construct().

Traces to the fix_impl.patch hunks in read_sql_construct (end-location tracking and
the "trim" hunk). The text is again taken from startlocation up to the location of the
terminating token (*yyllocp) and then trailing whitespace is stripped by hand. A
trailing "-- comment" is therefore kept in the expression with its newline removed,
so any text appended later (e.g. the ";" or a closing paren) ends up commented out.
The empty-input check goes back to comparing startlocation with *yyllocp.
The scanner token-length changes were left alone; they are harmless without a caller.

Failing oracle cases: see the oracle run (plpgsql_control, plpgsql regress).
