# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 25cd2d64021ae081cbcef1592e0ee04ddda2e975 ("Detect Julian-date overflow in timestamp[tz]_pl_interval."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||horology`
