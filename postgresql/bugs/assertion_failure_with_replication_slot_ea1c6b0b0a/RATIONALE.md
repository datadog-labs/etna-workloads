# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ea1c6b0b0aec43b1cd513945f618793ce3343347 ("Fix assertion failure with replication slot release in single-user mode"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/slot.c

Failing oracle cases:
- `src/test/modules/test_misc|t/008_replslot_single_user.pl|logical decoding`
- `src/test/modules/test_misc|t/008_replslot_single_user.pl|logical slot advance`
- `src/test/modules/test_misc|t/008_replslot_single_user.pl|physical slot advance`
