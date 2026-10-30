# Rationale

Changed `extractBoxOrReply` in `src/geo.c` only. This reverses the fix's hunk
that swapped height/width parsing ("Fix GEOSEARCH bybox width and height
mismatch bug"). Pre-fix, `argv[0]` was parsed as height and `argv[1]` as
width, while the syntax is `BYBOX <width> <height>`. So width and height are
swapped for every BYBOX search. The 9.0.7 code already uses the
new point-in-rectangle algorithm, so the other hunks are not reverted.

Failing oracle cases:
- GEOSEARCH non square, long and narrow
- GEOSEARCH fuzzy test - bybox
- GEOSEARCH box edges fuzzy test (only east/west found: box dimensions transposed)
