# Rationale

Changed hunk: `src/backend/access/spgist/spgscan.c`, `spgPrepareScanKeys()`.
Traces to the fix.patch hunk in spgPrepareScanKeys that adds the loop removing
NULL ORDER BY keys (building `numberOfNonNullOrderBys` / `nonNullOrderByOffsets`).
The condition `skey->sk_flags & SK_ISNULL` is disabled (`false && ...`), so NULL
order-by keys are no longer filtered out and are passed to the opclass
inner_consistent/leaf_consistent distance code as if non-NULL. That is the
original bug: KNN SP-GiST scans with a NULL ordering argument misbehave.

Failing oracle case: src/test/regress||create_index_spgist
