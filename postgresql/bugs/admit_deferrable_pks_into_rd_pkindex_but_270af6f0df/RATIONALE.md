# Re-introducing the bug fixed by 270af6f0df76

Fix 270af6f0df76 has two halves:
1. **Admit** deferrable PKs into `rd_pkindex`. It removed `!index->indimmediate` from the
   early `continue` and moved that check below the PK bookkeeping.
2. **Flag** them via `rd_ispkdeferrable`, so a deferrable PK is never used as the
   (default) replica identity and is hidden from `RelationGetPrimaryKeyIndex()`.

## Why the full reverse is not used

I first reversed both halves. That change built and ran, and all 3 oracle cases passed. In
REL_18_6, not-null constraints are catalogued, so deriving NOT NULL for inheritance children
no longer goes through `rd_pkindex`. The constraints-test symptom from the original fix
(`\d+ notnull_tbl4_*`) therefore cannot come back. The `notnull_tbl5` DROP CONSTRAINT test from
that commit no longer exists in the test suite.

The other half of the fix still matters in today's code. Its commit message says "in
particular don't return them as replica identity", and the publication test checks it.
So I reversed the **flag** half only. Deferrable PKs still go into `rd_pkindex`, as in today's
code, but are no longer marked as deferrable. This is the exact failure mode the fix's
publication test guards against: a deferrable PK becomes the default replica identity, which
the commit message warns can corrupt replicated data.

## Changed hunks

1. `src/backend/utils/cache/relcache.c`, `RelationGetIndexList()`: removed the local
   `bool pkdeferrable = false;`.
   Traces to fix hunk `@@ -4761,6 +4761,7 @@` (which added that variable).
2. `src/backend/utils/cache/relcache.c`, `RelationGetIndexList()`: the PK branch again only
   sets `pkeyIndex = index->indexrelid;` and no longer records
   `pkdeferrable = !index->indimmediate`.
   Traces to fix hunk `@@ -4832,7 +4833,13 @@`. The `if (!index->indimmediate) continue;` that
   follows is left in place, so deferrable indexes still can't be chosen as an explicit replica
   identity candidate.
3. `src/backend/utils/cache/relcache.c`, `RelationGetIndexList()`: no longer sets
   `rd_ispkdeferrable`, and the replica identity choice is back to
   `if (replident == REPLICA_IDENTITY_DEFAULT && OidIsValid(pkeyIndex))`. A deferrable PK is
   now selected as `rd_replidindex`, so it acts as the table's replica identity.
   Traces to fix hunk `@@ -4854,7 +4861,8 @@`.
4. `src/backend/utils/cache/relcache.c`, `RelationGetPrimaryKeyIndex()`: always returns
   `rd_pkindex`, so a deferrable PK is never hidden. The `deferrable_ok` branch, added later on
   top of the flag, collapses to this.
   Traces to fix hunk `@@ -4972,7 +4981,7 @@`
   (`return relation->rd_ispkdeferrable ? InvalidOid : relation->rd_pkindex;`).
5. `src/include/utils/rel.h`, `struct RelationData`: removed the `rd_ispkdeferrable` field.
   Traces to the rel.h hunk `@@ -150,7 +150,8 @@`.

Result: a table with `PRIMARY KEY DEFERRABLE` and default replica identity gets the deferrable
PK as its replica identity. An UPDATE on such a table in a publication that publishes updates
is accepted when it should be rejected. Logical replication of that table could also apply
changes keyed on a transiently non-unique key.

## Failing oracle cases

- `src/test/regress||publication` FAILS. The `UPDATE testpub_tbl5d SET a = 1;` no longer
  raises "cannot update table "testpub_tbl5d" because it does not have a replica identity and
  publishes updates".
- `src/test/regress||constraints` passes.
- `src/test/regress||replica_identity` passes. Its error comes from the separate
  non-immediate-index check in ALTER TABLE.


<!-- produced on retry with opus -->
