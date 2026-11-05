# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b4bd1385043c4664a7b8894a811ba91a61c6e07f ("Fix race with timeline selection in logical decoding during promotion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlog.c, src/backend/replication/walsender.c

Failing oracle cases:
- `src/test/recovery|t/035_standby_logical_decoding.pl|got expected output from pg_recvlogical during promotion timeline switch`
- `src/test/recovery|t/035_standby_logical_decoding.pl|pg_logical_slot_peek_changes works during promotion timeline switch`
- `src/test/recovery|t/035_standby_logical_decoding.pl|pg_recvlogical works during promotion timeline switch`
