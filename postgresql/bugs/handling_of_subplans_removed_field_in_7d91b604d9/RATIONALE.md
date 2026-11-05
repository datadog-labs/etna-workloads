# Rationale

File: src/backend/commands/explain.c

- `ExplainNode`: removed the early `switch` that emitted "Subplans Removed" as a property of the parent node (fix hunk "@@ -1967"). Instead, `ExplainMissingMembers` is called in the "special child plans" switch for T_Append / T_MergeAppend (fix hunk "@@ -2007"), i.e. after the "Plans" group is opened. The field is again emitted inside the Plans sub-node, which produces malformed or misplaced output in the structured formats (JSON/XML/YAML).
- `ExplainMissingMembers`: condition reverted to `nplans < nchildren` (dropped `|| es->format != EXPLAIN_FORMAT_TEXT`, hunk "@@ -3348"). Structured formats no longer always report the field, as in the buggy version.

Failing oracle case: src/test/regress||partition_prune
