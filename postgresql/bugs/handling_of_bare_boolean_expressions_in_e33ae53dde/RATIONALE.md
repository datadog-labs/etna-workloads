# Rationale
File: src/backend/statistics/mcv.c, function mcv_get_match_bitmap.
Traces to the fix.patch hunk replacing `elog(ERROR, "unknown clause type")` with a final else branch handling bare boolean-returning expressions via mcv_match_expression. I removed that branch and restored the elog(ERROR), so bare boolean expressions (e.g. `WHERE (a > 1)`-style expression stats entries) fail with "unknown clause type".

Failing oracle case: src/test/regress||stats_ext
