# Rationale

Hunk: src/backend/utils/adt/json.c, JsonEncodeDateTime() (DATEOID, TIMESTAMPOID, TIMESTAMPTZOID cases).
Traces to fix.patch hunks in json.c datum_to_json (and jsonb.c datum_to_jsonb), which replaced
a hard-coded DT_INFINITY with EncodeSpecialDate/EncodeSpecialTimestamp. In current code both json and jsonb
share JsonEncodeDateTime, so the three calls are replaced with strcpy(buf, "infinity"), so -infinity
is emitted as "infinity" again.

Failing oracle cases: src/test/regress||json, src/test/regress||jsonb (expected; see oracle output).
