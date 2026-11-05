# Rationale

## src/backend/utils/adt/tsginidx.c, checkcondition_gin()
Traces to the fix.patch hunks in tsginidx.c (TS_execute_ternary: NOT under a phrase
must be forced to MAYBE; PHRASE must never report TRUE). In current code that logic
moved into TS_execute/TS_phrase_execute, which rely on the GIN callback reporting MAYBE
(not TRUE) for any operand when position data is requested (`data != NULL`).
I removed `|| data != NULL` from the "replace TRUE with MAYBE" condition. Now a TRUE
operand without positions is returned to TS_phrase_execute as a definite match with
npos=0. Under NOT above/in a phrase, TRUE is inverted to NO (or hits the
"should not get here" path), and phrases get reported as definite instead of MAYBE.
This is the original bug: NOT over a phrase treats "matches somewhere" as "matches everywhere".

## Failing oracle cases
- src/regress||tsearch
