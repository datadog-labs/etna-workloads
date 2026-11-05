# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 627605713074e51f29b623cd799e37a9f411c57b ("Fix unlogged sequence corruption after standby promotion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/hash/hash_xlog.c, src/backend/access/transam/xlogutils.c, src/backend/commands/sequence.c, src/include/access/xlogutils.h

Failing oracle cases:
- `src/test/recovery|t/054_unlogged_sequence_promotion.pl|unlogged sequence can be read after standby promotion`
