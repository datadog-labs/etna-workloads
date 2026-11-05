# Rationale

File: src/backend/utils/adt/jsonfuncs.c, function populate_scalar().

Traces to the fix.patch hunks in populate_scalar. The fix replaced the manual wrapping of the string in quotes (with no escaping) by escape_json. I restored the old behaviour for json/jsonb targets with JSON_TOKEN_STRING input. The code now wraps the already-unescaped string value in double quotes and does not escape it. A string containing quotes, backslashes or control characters then yields an invalid JSON literal or a wrong value in json_to_record() json/jsonb output columns.

Failing oracle case: src/test/regress||json (jsonb still passes).
