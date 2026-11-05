# Rationale

File/function: src/backend/utils/adt/tsvector_op.c, TS_phrase_execute(), OP_NOT case, `case TS_MAYBE`.

Traces to the fix.patch hunks in tsginidx.c (TS_execute_ternary, `in_phrase`: "In phrase search, always return MAYBE since we lack positions" for NOT) and in tsvector_op.c, which made NOT under a phrase operator report uncertainty when position data is unavailable. In current code that logic is the `TS_MAYBE` branch under OP_NOT, which keeps the result MAYBE. I changed it to treat a MAYBE child as a definite match and flip the negate flag. A NOT below a phrase operator, evaluated lossily by GIN/GiST (TS_EXEC_PHRASE_NO_POS) or by positionless data, is then treated as a certain result instead of an uncertain one. This gives wrong phrase-search results.

Failing oracle cases: src/test/regress||tsearch, src/test/regress||tstypes.
