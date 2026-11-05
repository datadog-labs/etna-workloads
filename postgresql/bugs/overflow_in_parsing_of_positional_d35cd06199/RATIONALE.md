# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d35cd061998434747c0d1c0f6f2aa1f736f0edb4 ("Fix overflow in parsing of positional parameter"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/scan.l, src/interfaces/ecpg/preproc/pgc.l

Failing oracle cases:
- `src/test/regress||numerology`
