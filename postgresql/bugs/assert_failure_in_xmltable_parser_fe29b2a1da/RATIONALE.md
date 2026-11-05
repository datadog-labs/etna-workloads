# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fe29b2a1dab2b3d81e6c350679b7d9b0e1c8c850 ("Fix Assert failure in XMLTABLE parser"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/gram.y

Failing oracle cases:
- `src/test/regress||xml`
