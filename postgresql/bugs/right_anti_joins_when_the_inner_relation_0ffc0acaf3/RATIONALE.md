# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0ffc0acaf3bf301ba8fd43dc0e004b8b7c9ecd3a ("Fix right-anti-joins when the inner relation is proven unique"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeHashjoin.c, src/backend/executor/nodeMergejoin.c

Failing oracle cases:
- `src/test/regress||join`
