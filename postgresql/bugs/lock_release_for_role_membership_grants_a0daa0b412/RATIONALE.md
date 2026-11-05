# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a0daa0b4127dffe99a92c6606ad778f89ec3239f ("Fix lock release for role membership grants in DROP OWNED BY."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/dependency.c

Failing oracle cases:
- `src/test/isolation||drop-owned-grant`
