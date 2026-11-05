# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4989ce72644b9d636b9b23c7a1719a405e62670b ("MERGE ... DO NOTHING: require SELECT privileges"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_merge.c

Failing oracle cases:
- `src/test/regress||merge`
