# Rationale

Fix hunks (ext/misc/series.c, seriesFilter): both reversed in tree/ext/misc/series.c.

- Ascending (`bDesc==0`): `iTerm = iMax` replaced with the pre-fix
  `iTerm -= ceil((iTerm-iMax)/iStep)*iStep`. It aligns iTerm to the grid of the
  original terminal value, not of iBase. If (iTerm-iBase) is not a multiple of
  the step, iTerm falls off the series grid and the later "adjust iTerm" step
  then truncates the series too far.
- Descending: `iTerm = iMin` replaced with `iTerm += ceil((iMin-iTerm)/iStep)*iStep`.

Pre-fix code used `szStep` locals; in 3.54.1 the equivalent is `pCur->iStep`.

Failing oracle cases: tabfunc01-5.1 (generate_series(60,73,6) WHERE value=66
returns nothing), tabfunc01-5.2 (descending, value=67), plus tabfunc01-1301 and
tabfunc01-1302.
