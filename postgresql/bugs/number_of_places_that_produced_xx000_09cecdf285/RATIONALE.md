# Rationale

Changed hunk: src/backend/utils/adt/xid8funcs.c, parse_snapshot() `bad_format:` label.
Traces to the fix.patch hunk in txid.c parse_snapshot (elog(ERROR, "invalid input for txid_snapshot") replaced by
ereport with ERRCODE_INVALID_TEXT_REPRESENTATION). The reverse: bad input now raises an elog() internal error
(SQLSTATE XX000) with a different message instead of the proper 22P02 "invalid input syntax for type pg_snapshot".
The soft-error (escontext) path is lost as well.

Failing oracle case: src/test/regress||txid
