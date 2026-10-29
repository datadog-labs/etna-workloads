# Rationale

Only the vdbeaux.c hunk of the fix still applies in a recognisable form. The
pragma.c and vdbe.c hunks (aRoot layout/assert) already match the post-fix
layout in 3.54.1 and are left alone; nothing there was the bug.

## src/vdbeaux.c, displayP4, case P4_INTARRAY
Fix hunk: `for(i=1; i<n; i++)` -> `for(i=1; i<=n; i++)`. Reversed by changing
the loop in 3.54.1 (now using u32 and sqlite3_str_appendf) back to `i<n`. The
array holds the count in ai[0] followed by n elements, so the last element is
omitted from EXPLAIN output.

## Oracle
pragma4-2.100 fails: EXPLAIN PRAGMA integrity_check renders the IntegrityCk P4
list without its last root page, so the expected `x[0-9]+,1x` pattern does not match.
