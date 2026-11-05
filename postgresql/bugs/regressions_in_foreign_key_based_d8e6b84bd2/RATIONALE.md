# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d8e6b84bd2ac045cdbae231012ab5ea4471a02cd ("Avoid regressions in foreign-key-based selectivity estimates."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/costsize.c

Failing oracle cases:
- `src/test/regress||join`
