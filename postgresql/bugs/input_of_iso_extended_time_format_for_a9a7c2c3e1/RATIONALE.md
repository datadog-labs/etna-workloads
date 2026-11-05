# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a9a7c2c3e15ede7a4f6b44d72a32b105b9113f02 ("Fix input of ISO "extended" time format for types time and timetz."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/datetime.c

Failing oracle cases:
- `src/test/regress||horology`
