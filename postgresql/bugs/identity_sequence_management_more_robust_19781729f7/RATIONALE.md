# Rationale

**File/function:** src/backend/catalog/pg_depend.c, `getIdentitySequence()`.

**Traces to:** the fix.patch hunk in pg_depend.c that introduced `getOwnedSequences_internal(..., deptype)` and made `getIdentitySequence` call it with `DEPENDENCY_INTERNAL`. The old `getOwnedSequence` took no dependency-type filter.

**Change:** `getIdentitySequence` now passes deptype 0 instead of `DEPENDENCY_INTERNAL`. It therefore also matches AUTO-dependency (serial) sequences owned by the column, not only the identity sequence. A column that has both an identity sequence and an owned serial sequence now hits "more than one owned sequence found". The lookup can also return a serial sequence where an identity sequence is expected.

**Failing oracle case:** src/test/regress||identity
