# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d074b4e50d11768ab6da696b13d40ec05e4823fb ("Fix regexp_matches() handling of zero-length matches."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/regexp.c, src/backend/utils/adt/varlena.c

Failing oracle cases:
- `src/test/regress||strings`
