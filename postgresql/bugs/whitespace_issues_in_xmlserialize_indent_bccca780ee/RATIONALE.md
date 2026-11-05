# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bccca780eef904002512a1a0b5ce617bcb63507b ("Fix some whitespace issues in XMLSERIALIZE(... INDENT)."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/xml.c

Failing oracle cases:
- `src/test/regress||xml`
