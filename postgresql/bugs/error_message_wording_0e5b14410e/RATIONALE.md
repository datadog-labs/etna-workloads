# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0e5b14410e2bb54d191bbb7bb21a674ccabe768e ("Fix error message wording"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/interfaces/ecpg||sql/sqljson`
- `src/test/regress||sqljson`
