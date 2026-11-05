# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c39f2f68e95a54e430c6a7b7d1e9f98cedff5aff ("Fix publication syntax error message"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/gram.y

Failing oracle cases:
- `src/test/regress||publication`
