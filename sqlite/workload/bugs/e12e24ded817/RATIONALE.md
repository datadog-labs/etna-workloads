# Rationale

Fix hunk (json1.c, jsonParseValue): the string-scanning loop changed from
`if( c==0 ) return -1;` to `if( c<=0x1f ) return -1;`, rejecting control
characters inside strings.

In 3.54.1 the logic lives in `jsonTranslateTextToBlob` (src/json.c), `parse_string`
branch. Control characters (`c<=0x1f`, non-NUL) are currently marked
`JSONB_TEXT5` and `hasNonstd=1`, so strict `json_valid()` rejects them (they are
JSON5-only). I removed that branch body, leaving only the `c==0` rejection, which
is exactly the pre-fix behaviour: only NUL terminates/rejects, other control
characters are accepted as ordinary string content and the text is canonical.

Oracle: json102-1500 fails (json_valid returns true for strings containing
control characters 1..31, instead of only 32 passing).
