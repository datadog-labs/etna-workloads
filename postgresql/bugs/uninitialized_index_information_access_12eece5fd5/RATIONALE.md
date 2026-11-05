# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 12eece5fd54c2aa3dbdefb6de7f18566f5c00357 ("Fix uninitialized index information access during apply."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execIndexing.c, src/backend/executor/execReplication.c, src/backend/replication/logical/worker.c

Failing oracle cases:
- `src/test/subscription|t/035_conflicts.pl|multiple_unique_conflicts detected on a leaf partition during insert`
