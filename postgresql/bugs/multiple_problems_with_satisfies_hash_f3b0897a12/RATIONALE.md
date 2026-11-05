# Rationale

Changed: src/backend/partitioning/partbounds.c, `satisfies_hash_partition()`.
Removed the early check `if (PG_ARGISNULL(0) || PG_ARGISNULL(1) || PG_ARGISNULL(2)) PG_RETURN_BOOL(false);`.
Traces to the fix.patch hunk that added the "Return null if the parent OID, modulus, or remainder is NULL" check
(today's code returns false instead of null, so that check is what was removed). Without it,
PG_GETARG_OID/INT32 read NULL arguments as garbage values, which was the original bug (wrong results or errors on NULL
parent/modulus/remainder).

Failing oracle case: src/test/regress||hash_part
