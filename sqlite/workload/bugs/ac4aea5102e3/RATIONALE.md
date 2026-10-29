# Rationale

Fix hunk (src/json.c, jsonReplaceNode): the old json_insert() code duplicated the
string argument with `sqlite3DbStrDup(0, z)` (a NUL-terminated C-string copy,
which ignores the real length `n`); the fix copied exactly `n` bytes with memcpy.
The string was treated as a C string, so embedded U+0000 characters were mishandled.

In version-3.54.1 jsonReplaceNode no longer exists; JSON values are converted to
JSONB in `jsonFunctionArgToBlob` (src/json.c, SQLITE_TEXT case). The non-JSON
text path calls `jsonBlobAppendNode(pParse, JSONB_TEXTRAW, nJson, zJson)` with the
true byte length (`sqlite3_value_bytes`). I changed the length to `strlen(zJson)`,
re-introducing the same defect: the text argument is treated as a NUL-terminated
C string, so content after the first embedded U+0000 is dropped.

Oracle: json101-4.9 (`json_insert('{"a":1}','$.b',CAST(x'0000' AS text))`) fails;
it yields `{"a":1,"b":""}` instead of `{"a":1,"b":"\u0000\u0000"}`.
The other 281 cases pass.
