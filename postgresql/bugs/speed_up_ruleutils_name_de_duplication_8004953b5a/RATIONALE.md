# Rationale
File: src/backend/utils/adt/ruleutils.c (fix.patch's ruleutils.c hunks for overlength names)

1. `set_rtable_names`: fix hunk that added the truncation loop (pg_mbcliplen, keep digits within NAMEDATALEN) for generated names. Reverted to a plain `sprintf(modname, "%s_%d", ...)` with a +32 buffer, so a long refname gets a suffix that exceeds NAMEDATALEN and is later truncated, cutting off the digits and yielding duplicate names.
2. `make_colname_unique`: same hunk for column names, reverted the same way.

The hash-table speedup is already present and was left untouched; the bug re-expressed is the overlength-name case.

Expected failing oracle case: src/test/regress||create_view
