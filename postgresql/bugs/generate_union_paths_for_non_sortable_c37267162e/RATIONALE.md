# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c37267162e889fe783786b9e28d1b65b82365a00 ("Fix generate_union_paths for non-sortable types."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepunion.c

Failing oracle cases:
- `src/test/regress||union`
