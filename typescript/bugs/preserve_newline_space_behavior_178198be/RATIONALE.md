# Rationale
One hunk in `tree/src/compiler/emitter.ts`, `emitEmbeddedStatement`: removed the `preserveSourceNewlines && !getLeadingLineTerminatorCount(parent, node, ListFormat.None)` condition. This matches the single hunk of fix.diff, which added that condition. Without it, embedded statements that were on the same line as their parent are moved to a new line, so the source newline/space layout is not preserved.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
