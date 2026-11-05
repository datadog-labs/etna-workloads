# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a32ca7883629f6b1fbbf0bd2e2aa11ec86edb6b3 ("Fix CREATE VIEW to allow zero-column views."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/view.c

Failing oracle cases:
- `src/test/regress||create_view`
