# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8af310b331940ff5efd19402a3f8ee5521eb821a ("Prevent creation of duplicate not-null constraints for domains"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/typecmds.c

Failing oracle cases:
- `src/test/regress||domain`
