repro.sql calls substr()/substring() with a NULL start or length argument.
Clean shell returns NULL for each, so the query prints `nil` three times.
The buggy shell doesn't return NULL and returns non-NULL values instead (e.g. `abcdefg` for substring with NULL length).
