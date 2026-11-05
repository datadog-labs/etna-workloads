# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9ec6199d18d6235cc4b4d5e4e8986e73b55b14d8 ("Fix possible crash with nested SubLinks."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/subselect.c

Failing oracle cases:
- `src/test/regress||subselect`
