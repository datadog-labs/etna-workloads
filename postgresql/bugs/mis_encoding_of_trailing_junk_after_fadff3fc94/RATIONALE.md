# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fadff3fc94598db1d87e4242821964fb2850e19e ("Prevent mis-encoding of "trailing junk after numeric literal" errors."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/scan.l, src/fe_utils/psqlscan.l, src/interfaces/ecpg/preproc/pgc.l

Failing oracle cases:
- `src/test/regress||numerology`
