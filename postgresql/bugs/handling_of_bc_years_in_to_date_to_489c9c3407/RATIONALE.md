# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 489c9c3407cbfd473c2f8d7863ffaaf6d2e8fcf8 ("Fix handling of BC years in to_date/to_timestamp."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/formatting.c

Failing oracle cases:
- `src/test/regress||horology`
