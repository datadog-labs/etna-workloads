# Rationale

## src/backend/utils/adt/ruleutils.c, pg_get_functiondef()
Traces to the ruleutils.c hunk of fix.patch (replacing the hardcoded
DateStyle/search_path test with `GetConfigOptionFlags(...) & GUC_LIST_QUOTE`).
I reverted the condition to the hardcoded name test, so only DateStyle and
search_path are treated as list-quoted. Other GUC_LIST_QUOTE variables such as
temp_tablespaces and the *_preload_libraries are emitted as a single quoted
literal, which mangles their values. The later list-splitting code is unchanged.
Only the ruleutils.c hunk was reverted. The pg_dump hunks were not touched,
because the oracle covers only the `rules` test.

## Failing oracle cases
- src/test/regress||rules
