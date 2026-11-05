# Rationale
All changes are in src/backend/parser/parse_func.c, ParseFuncOrColumn().

1. `could_be_projection`: dropped the `!proc_call` term (fix hunk 2), so `CALL x(rec)` can be taken as column projection.
2. Wrong-kind-of-routine check: removed FUNCDETAIL_AGGREGATE from the unified "is not a procedure" check (fix hunk 3), and re-added the old
   aggregate-branch check (fix hunk 4) with ERRCODE_UNDEFINED_FUNCTION and no "To call a function, use SELECT." hint.

Failing oracle case: src/test/regress||create_procedure (`CALL sum(1)` loses its HINT).
