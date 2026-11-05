# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bfc7dff26d53ab42fe6cb6bc2243f5241a6df3e4 ("Fix integer overflow in nodeWindowAgg.c"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeWindowAgg.c

Failing oracle cases:
- `src/test/regress||window`
