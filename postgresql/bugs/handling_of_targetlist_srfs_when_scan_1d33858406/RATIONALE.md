# Rationale

## src/backend/optimizer/path/joinrels.c, is_dummy_rel()
Traces to the fix.patch hunk that makes `is_dummy_rel` descend through
ProjectionPath / ProjectSetPath before testing IS_DUMMY_APPEND. I removed that
descent loop, so only the first path itself is tested. When a dummy rel gets a
ProjectSetPath/ProjectionPath on top (targetlist SRFs applied to a known-empty
scan/join rel), the rel is no longer recognized as dummy, so SRF handling on
an empty rel goes wrong (e.g. wrong row output).

## Failing oracle cases
- src/test/regress||tsrf
