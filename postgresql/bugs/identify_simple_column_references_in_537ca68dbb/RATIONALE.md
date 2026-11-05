# Rationale
File: src/src/backend/commands/statscmds.c, function CreateStatistics.
Traces to fix.patch hunk adding `else if (IsA(selem->expr, Var))` branch (column reference in parens). Removed that whole branch (including its later-added virtual generated column check), so "(a)" is again treated as a complex expression instead of a simple column attnum.
(The comment and lsyscache.h include hunks were left alone; they are non-functional.)

Failing oracle cases: src/test/regress||stats_ext
