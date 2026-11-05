# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bd5ddbe8666a11e34ba77e4c1788c4832dcd9a50 ("Fix ALTER EXTENSION SET SCHEMA with objects outside an extension's schema"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/extension.c

Failing oracle cases:
- `src/test/modules/test_extensions||test_extensions`
