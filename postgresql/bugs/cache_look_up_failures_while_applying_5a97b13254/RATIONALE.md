# Rationale

Changed: `src/backend/replication/logical/relation.c`, function `logicalrep_partmap_invalidate_cb`.
Traces to the first three hunks of fix_impl.patch (the same function in relation.c). The fix changed the
iteration variable from `LogicalRepRelMapEntry *` to `LogicalRepPartMapEntry *`, and accessed fields through `entry->relmapentry.`.
I reverted those: `entry` is again a `LogicalRepRelMapEntry *` and the hash_seq_search results are cast to it.
LogicalRepPartMap entries are `LogicalRepPartMapEntry` (partoid key first, then relmapentry). With the wrong
type, `localreloid` is read and `localrelvalid` written at the wrong offset. So invalidation either doesn't match
the right partition entry or corrupts other fields, and stale cache entries are used or lookups fail.

The other fix hunks (logicalrep_partition_open rebuild logic) were left in place; the bug was re-expressed only in the callback.

Failing oracle cases (3/74), all in src/test/subscription t/013_partition.pl:
- updates of tab5 replicated correctly#2
- updates of tab5 replicated correctly after altering table on publisher
- updates of tab5 replicated correctly after altering table on subscriber
