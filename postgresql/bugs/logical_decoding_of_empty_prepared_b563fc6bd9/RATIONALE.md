# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b563fc6bd926fd9dca86d0c1a16fbf2e3e63dee9 ("Fix logical decoding of empty prepared transactions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/logical/reorderbuffer.c

Failing oracle cases:
- `src/test/subscription|t/021_twophase.pl|check replication origin was dropped on subscriber`
- `src/test/subscription|t/021_twophase.pl|check replication slot was dropped on publisher`
- `src/test/subscription|t/021_twophase.pl|check subscription relation status was dropped on subscriber`
- `src/test/subscription|t/021_twophase.pl|check subscription was dropped on subscriber`
- `src/test/subscription|t/021_twophase.pl|empty prepared transaction is not replicated`
- `src/test/subscription|t/021_twophase.pl|initial data in subscriber table`
- `src/test/subscription|t/021_twophase.pl|initial data in subscriber table#2`
- `src/test/subscription|t/021_twophase.pl|publisher inserted data`
- `src/test/subscription|t/021_twophase.pl|replicated data in subscriber table`
- `src/test/subscription|t/021_twophase.pl|replicated data in subscriber table#2`
- `src/test/subscription|t/021_twophase.pl|replication continues after an empty prepared transaction`
- `src/test/subscription|t/021_twophase.pl|should be no prepared transactions on subscriber`
- `src/test/subscription|t/021_twophase.pl|should be no prepared transactions on subscriber#2`
- `src/test/subscription|t/021_twophase.pl|transaction is prepared on subscriber#5`
- `src/test/subscription|t/021_twophase.pl|two-phase is enabled`
- `src/test/subscription|t/021_twophase.pl|two-phase should be enabled`
- `src/test/subscription|t/021_twophase.pl|two-phase slot option should be disabled`
- `src/test/subscription|t/021_twophase.pl|two-phase subscription option should be disabled`
