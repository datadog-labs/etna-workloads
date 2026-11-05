# Rationale

File: src/backend/parser/parse_merge.c, function transformMergeStmt.
Traces to the single hunk of fix_impl.patch ("Check for unreachable WHEN clauses").

Restored the old logic:
`if (condition == NULL) is_terminal[kind] = true; else if (is_terminal[kind]) ereport(ERROR)`.
An unconditional WHEN clause now only marks the match kind terminal and is never checked
against it. A second unconditional clause of the same kind after an unconditional one is
therefore no longer reported as unreachable.

Failing oracle case: src/test/regress||merge
