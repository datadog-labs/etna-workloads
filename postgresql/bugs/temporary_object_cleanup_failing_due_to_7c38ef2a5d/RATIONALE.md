# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7c38ef2a5d6cf6d8dc3834399d7a1c364d64ce64 ("Fix temporary object cleanup failing due to toast access without snapshot."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/namespace.c

Failing oracle cases:
- `src/test/isolation||temp-schema-cleanup`
