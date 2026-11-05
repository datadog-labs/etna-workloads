# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3850d4dec1d91c4fdce274f42986840444d5593e ("Avoid integer overflow hazard in interval_time()."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/date.c

Failing oracle cases:
- `src/test/regress||horology`
