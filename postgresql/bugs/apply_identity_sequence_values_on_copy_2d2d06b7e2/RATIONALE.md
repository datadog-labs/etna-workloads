# Rationale

## src/backend/commands/copyfrom.c, CopyFrom setup (BeginCopyFrom equivalent)
Traces to the copy.c hunk in fix_impl.patch (BeginCopyFrom: identity columns get a NextValueExpr from the owned sequence).
Today's build_column_default() already builds the NextValueExpr for identity columns, so the fix is now implicit.
To restore the bug, the default-expression setup skips identity columns (defexpr = NULL). Columns omitted from COPY's column list then get no sequence value (NULL, so a NOT NULL violation).
