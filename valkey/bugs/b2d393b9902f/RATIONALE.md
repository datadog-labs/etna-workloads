# Rationale

## Changed: src/geohash_helper.c, geohashCalculateAreasByShapeWGS84()

The fix's second hunk replaced the "decrease_step" check, which compared
the distance from the center to each neighbor edge against `radius_meters`,
with a comparison of the neighbor edges against the bounding box
(`north.latitude.max < max_lat`, etc.). I restored the four old
`geohashGetDistance(...) < radius_meters` checks. `radius_meters` and the
local `longitude`/`latitude` still exist in 9.0.7, so the old code works
unchanged. The result is the same defect. The step isn't reduced when the
bounding box extends past the neighbor squares, so points in the box but
outside the radius, such as oblique ones near the poles, are missed.

The fix's first hunk only changed an ASCII-art comment, so I left it alone.

## Failing oracle cases (2 of 73)
- `GEORADIUSBYMEMBER search areas contain satisfied points in oblique direction`: returns `n1` instead of `n1 n2`.
- `GEORADIUSBYMEMBER crossing pole search`: returns `n1` instead of `n1 n2`.
