# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8ec8fe0f31712c62b761da9ef6d32214e08340d1 ("Message style fix"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c

Failing oracle cases:
- `src/test/regress||hash_part`
