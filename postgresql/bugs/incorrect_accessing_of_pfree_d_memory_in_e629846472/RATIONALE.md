# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e629846472255c7a636c453a522755ef05489c90 ("Fix incorrect accessing of pfree'd memory in Memoize"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeMemoize.c

Failing oracle cases:
- `src/test/regress||memoize`
