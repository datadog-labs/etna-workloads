# Rationale

Hunk: src/backend/utils/adt/tsvector_op.c, `TS_execute_recurse()` (case OP_PHRASE).

Traces to the fix.patch hunk in TS_phrase_execute / TS_execute that changed
`return true` into `return (flags & TS_EXEC_PHRASE_AS_AND) ? true : false`.
Today's code expresses the "no position info" case as TS_MAYBE, which is turned
into TS_NO unless the caller passed TS_EXEC_PHRASE_NO_POS (the successor of
TS_EXEC_PHRASE_AS_AND). I made it return TS_YES unconditionally, so a phrase
operator whose operands lack positions falls back to AND even when the caller
did not ask for it (e.g. ts_match on a stripped tsvector).

Failing oracle case: src/test/regress||tsearch
