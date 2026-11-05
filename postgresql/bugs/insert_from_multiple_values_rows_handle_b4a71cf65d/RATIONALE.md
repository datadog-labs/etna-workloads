# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b4a71cf65d70b98aaf890b13ec600e340ff69e3f ("Make INSERT-from-multiple-VALUES-rows handle domain target columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/analyze.c, src/backend/parser/parse_target.c, src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||insert`
