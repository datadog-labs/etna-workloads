# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4bff3aa51c194e31044da8177f91eecb0b30205b ("Fix second race with timeline selection during promotion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlogutils.c

Failing oracle cases:
- `src/test/recovery|t/035_standby_logical_decoding.pl|pg_logical_slot_peek_changes works during promotion timeline switch`
