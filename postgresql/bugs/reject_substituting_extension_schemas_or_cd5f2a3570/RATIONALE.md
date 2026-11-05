# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cd5f2a357014d5ed8205191f8e1fb180f1439599 ("Reject substituting extension schemas or owners matching ["$'\]."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/extension.c

Failing oracle cases:
- `src/test/modules/test_extensions||test_extensions`
