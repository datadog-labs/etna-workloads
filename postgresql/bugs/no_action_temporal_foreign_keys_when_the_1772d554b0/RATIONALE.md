# Rationale

File: src/backend/utils/adt/ri_triggers.c, function ri_restrict (two hunks), tracing to the ri_triggers.c hunks of fix.patch.

1. The early `ri_Check_Pk_Match` shortcut again applies to PERIOD foreign keys. The fix added `!riinfo->hasperiod` to this condition. With the condition reverted, NO ACTION temporal FKs use the plain equality-based replacement-row check, which is wrong when the referenced range endpoints change.
2. The temporal query-building block (the intersect and range_agg `<@` replacement check) is disabled with `false &&`. The fix added this block. Without it the NO ACTION check ignores the remaining PK history.

The catalog and operator plumbing from the fix (the intersect operator OID and the extra FindFKPeriodOpers argument) is left in place. It is unused without the block.

Failing oracle case: src/test/regress||without_overlaps
