# Rationale

Changed: src/backend/utils/adt/ruleutils.c, pg_get_functiondef().
Traces to the ruleutils.c hunk of fix.patch. In the GUC_LIST_QUOTE branch, the
fix split the proconfig value with SplitGUCList() and emitted each element via
simple_quote_literal(). I restored the old behavior: append the stored value
verbatim (`appendStringInfoString(&buf, pos)`). Zero-length or over-long list
elements are then re-parsed by the SQL parser and mangled.

Only the ruleutils.c hunk was reverted. The SplitGUCList helpers stay in place,
unused here. The pg_dump hunks were not touched.

Failing oracle case: src/test/regress||rules
