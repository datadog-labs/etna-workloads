# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b0feda79fdf02710a6039a324299525845a4a9d4 ("Fix jsonb subscripting to cope with toasted subscript values."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonb_gin.c, src/backend/utils/adt/jsonb_op.c, src/backend/utils/adt/jsonfuncs.c

Failing oracle cases:
- `src/test/regress||jsonb`
