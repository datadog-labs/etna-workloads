# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 79b58c6f684315d39dfdbd721da7576d90bd9f99 ("Make pull_var_clause() handle GroupingFuncs exactly like Aggrefs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/var.c

Failing oracle cases:
- `src/test/regress||groupingsets`
