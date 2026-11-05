# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b7658c24c7c1ffad131a7fdf67ce7fc008be1177 ("Fix data inconsistency between publisher and subscriber."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/logical/relation.c, src/backend/replication/logical/worker.c, src/include/replication/logicalrelation.h

Failing oracle cases:
- `src/test/subscription|t/013_partition.pl|updates of tab5 replicated correctly after altering table on publisher`
- `src/test/subscription|t/013_partition.pl|updates of tab5 replicated correctly#2`
