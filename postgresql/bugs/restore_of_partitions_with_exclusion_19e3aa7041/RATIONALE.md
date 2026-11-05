# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 19e3aa704126f34f8fa4b36109478a7e6727a5e5 ("Fix restore of partitions with exclusion constraints"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/index.c

Failing oracle cases:
- `src/test/regress||indexing`
