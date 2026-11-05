# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4c777d6dd9c9ac8fc8316329745ed1177989379d ("Fix handling of namespace nodes in xpath() (xml)"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/xml.c

Failing oracle cases:
- `src/test/regress||xml`
