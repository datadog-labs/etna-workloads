# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a11b3bd37f14386310f25e89529bd3de8cd64383 ("Fix misprocessing of equivalence classes involving record_eq()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/equivclass.c

Failing oracle cases:
- `src/test/regress||join`
