# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2f7ffe124a9ba0ddc477fa5643da5e59cc1e4db0 ("Don't advance origin during apply failure."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/replication/logical/worker.c

Failing oracle cases:
- `src/test/subscription|t/023_twophase_stream.pl|check replication origin was dropped on subscriber`
- `src/test/subscription|t/023_twophase_stream.pl|check replication slot was dropped on publisher`
- `src/test/subscription|t/023_twophase_stream.pl|check subscription relation status was dropped on subscriber`
- `src/test/subscription|t/023_twophase_stream.pl|check subscription was dropped on subscriber`
- `src/test/subscription|t/023_twophase_stream.pl|transaction is committed on subscriber after retrying`
