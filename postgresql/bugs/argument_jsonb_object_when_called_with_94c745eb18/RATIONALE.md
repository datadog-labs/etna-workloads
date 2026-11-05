# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 94c745eb189e2122a3ff86c24443b11408ea2376 ("Fix two-argument jsonb_object when called with empty arrays"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonb.c

Failing oracle cases:
- `src/test/regress||jsonb`
