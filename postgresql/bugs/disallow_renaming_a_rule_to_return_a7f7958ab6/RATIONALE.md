# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a7f7958ab6bf368236334ce52e45be5e7502d2e7 ("Disallow renaming a rule to "_RETURN"."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteDefine.c

Failing oracle cases:
- `src/test/regress||rules`
