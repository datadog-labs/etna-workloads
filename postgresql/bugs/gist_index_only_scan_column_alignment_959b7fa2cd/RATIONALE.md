# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 959b7fa2cd603ec353aaef715993d0f0816febd2 ("Fix GiST index-only scan column alignment issue."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeIndexonlyscan.c

Failing oracle cases:
- `src/test/regress||gist`
