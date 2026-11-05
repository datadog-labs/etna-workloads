# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9f404d7922e8831dc49bfa225530ba5309900e4e ("Properly prepare varinfos in estimate_multivariate_bucketsize()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/selfuncs.c

Failing oracle cases:
- `src/test/regress||stats_ext`
