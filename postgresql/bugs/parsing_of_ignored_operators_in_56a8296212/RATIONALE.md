# Rationale

File: src/backend/utils/adt/tsquery.c, function gettoken_query_websearch(), case WAITOPERATOR.
Traces to the fix.patch hunk that rewrote WAITOPERATOR: the fix removed the special-case for '"' and added
`else if (ISOPERATOR(state->buf)) { buf++; continue; }` so that other operators are ignored in this state.
Reverted: restored the `"` special case (implicit AND, handled in WAITOPERAND) and removed the ISOPERATOR
ignore branch, so an operator char directly after an operand (e.g. `foo(bar`, `foo&bar`) is treated as the start of a new
operand and reaches gettoken_tsvector(), which errors / misparses instead of ignoring it.

(The comment-only hunk and the reordering in the last branch are cosmetic and were left alone.)

Failing oracle case: src/test/regress||tsearch
