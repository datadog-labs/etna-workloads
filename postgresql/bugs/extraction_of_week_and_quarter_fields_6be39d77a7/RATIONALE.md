# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6be39d77a70df52d5a0f2eb414ef9901ccf17e5a ("Fix extraction of week and quarter fields from intervals."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||interval`
