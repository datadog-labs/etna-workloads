# Rationale
File: src/backend/utils/misc/guc_tables.c (today the GUC table and variable live here, not guc.c).
- ConfigureNamesBool: removed the `default_with_oids` entry. Traces to the guc.c ConfigureNamesBool hunk.
- Removed the `default_with_oids` variable definition. Traces to the `bool default_with_oids = false;` hunk.
The check_default_with_oids hook (variable.c / guc_hooks.h) is left in place but unused.
Effect: `SET default_with_oids = false` in old dump files errors with "unrecognized configuration parameter" again.

Failing oracle case: src/test/regress||guc
