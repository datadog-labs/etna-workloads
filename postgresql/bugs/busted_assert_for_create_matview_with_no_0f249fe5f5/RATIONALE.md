# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0f249fe5f5cb3c83fd8e05743740b35ff5d34196 ("Fix busted Assert for CREATE MATVIEW ... WITH NO DATA."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/spi.c

Failing oracle cases:
- `src/test/regress||matview`
