# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cd2624fd97b0c36b68da278abc5362647f69b07d ("Fix PL/pgSQL's handling of integer ranges containing underscores."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/scan.l, src/fe_utils/psqlscan.l, src/interfaces/ecpg/preproc/pgc.l

Failing oracle cases:
- `src/test/regress||numerology`
