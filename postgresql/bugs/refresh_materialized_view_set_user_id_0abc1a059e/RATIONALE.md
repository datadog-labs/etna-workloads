# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0abc1a059e27c5a71a1a186c97d9c0af407469cc ("In REFRESH MATERIALIZED VIEW, set user ID before running user code."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/matview.c

Failing oracle cases:
- `src/test/regress||privileges`
