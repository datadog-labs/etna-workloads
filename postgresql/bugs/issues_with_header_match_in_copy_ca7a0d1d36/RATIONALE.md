# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ca7a0d1d368216e89359c63531a4df0b99a437e4 ("Fix two issues with HEADER MATCH in COPY"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/copy.c, src/backend/commands/copyfromparse.c

Failing oracle cases:
- `src/test/regress||copy`
