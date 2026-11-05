# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 45392626c95c6345d48c1b1b7541add0102ba59f ("Fix hash join when inner hashkey expressions contain Params."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/subselect.c

Failing oracle cases:
- `src/test/regress||join_hash`
