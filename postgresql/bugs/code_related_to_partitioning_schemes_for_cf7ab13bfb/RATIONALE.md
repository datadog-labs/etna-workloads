# Rationale

The original hunk (allpaths.c, set_append_rel_size) skipped NULL `translated_vars`
entries (dropped parent columns) before dereferencing them. That attr_needed loop no
longer exists in REL_18_6. The only code that still walks `translated_vars` per column
and guards against dropped columns is `translate_col_privs()`.

## Changed hunk
- File/function: src/backend/optimizer/util/inherit.c, `translate_col_privs`
- Traces to: the fix.patch hunk in allpaths.c that added `if (var == NULL) continue;`
- Change: removed the `if (var == NULL) /* ignore dropped columns */ continue;` guard.
  The `var->varattno` read now happens unconditionally at the top of the loop body
  (`child_attno`). Without this move, removing the guard alone is harmless, because a
  dropped column's bit is never set in the parent privileges.
- Why it restores the bug: a dropped parent column has a NULL `translated_vars` entry.
  It is now dereferenced, so `SELECT * FROM list_parted` after `DROP COLUMN b` on a
  partitioned table crashes.

## Failing oracle cases
- src/test/regress||alter_table
