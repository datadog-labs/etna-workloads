# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c31b0fca059cf081679be1689b59b21912b0d29e ("Reject infinite and out-of-range interval shifts in uuidv7()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/uuid.c

Failing oracle cases:
- `src/test/regress||uuid`
