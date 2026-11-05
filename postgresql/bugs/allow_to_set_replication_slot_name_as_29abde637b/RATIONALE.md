# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 29abde637bbb4b8fcdc96e049813890afa5ab671 ("Don't allow to set replication slot_name as ''."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c

Failing oracle cases:
- `src/test/regress||subscription`
