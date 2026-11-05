# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b2d6b4c728a282f9bbe9ff4fac02a872bef074dd ("ecpg: Fix return code for overflow in numeric conversion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/compatlib/informix.c

Failing oracle cases:
- `src/interfaces/ecpg||compat_informix/dec_test`
