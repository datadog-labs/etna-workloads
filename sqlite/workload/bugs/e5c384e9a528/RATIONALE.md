# Rationale

Fix hunk (src/json.c, jsonSetFunc): replaced `bIsSet = sqlite3_user_data(ctx)!=0`
with a test of the JSON_ISSET bit. Before the fix, any nonzero user data meant
"set". jsonb_insert() carries JSON_BLOB (0x10) in its user data, so it behaved
like jsonb_set().

In 3.54.1 jsonSetFunc decodes the insert type from bits 0xC. I re-added the old
rule: `if( eInsType==0 && flags!=0 ) eInsType = 1;` (nonzero user data => set).
json_insert has user data 0 and stays correct. jsonb_insert has JSON_BLOB only,
so it becomes set. The json_*_array_insert functions have JSON_AINS, so they
keep their own type.

Oracle cases that fail: json102-320-3 and json102-320-4
(`json(jsonb_insert('{"a":2,"c":4}','$.a',99))` returns a=99 instead of a=2).
