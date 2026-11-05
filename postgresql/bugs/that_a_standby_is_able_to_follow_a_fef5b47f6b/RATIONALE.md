# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fef5b47f6bfc9bfec619bb2e6e66b027e7ff21a3 ("Ensure that a standby is able to follow a primary on a newer timeline."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/walsender.c

Failing oracle cases:
- `src/test/recovery|t/004_timeline_switch.pl|check content of standby 3`
