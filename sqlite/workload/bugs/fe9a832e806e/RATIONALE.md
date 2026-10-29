# Rationale

Fix hunk (json1.c, jsonLookupStep): the label node for a newly inserted key was
built from the raw path text (`i`, `zPath`, including the surrounding quotes)
instead of the parsed key (`nKey`, `zKey`).

In 3.54.1 (src/json.c, jsonLookupStep, the `eEdit>=JEDIT_INS` branch) the label
is written as a JSONB header plus a memcpy. I reverted all four uses of the
parsed key (`nKey`/`zKey`) to the raw path span (`i`/`zPath`): the header size
passed to jsonBlobAppendNode, the size passed to jsonBlobMakeEditable, `nIns`,
and the memcpy source/advance. For unquoted keys `i==nKey` and `zPath==zKey`,
so behaviour is unchanged. For quoted keys the stored label includes the quotes.

Failing oracle case: json104-405. `json_set(x,'$."d"',4)` inserts the label
`"d"` with literal quotes, so `json_extract(x,'$."d"')` doesn't find `d` and
returns `{}` instead of 4. 404 passes because `b` already exists and so is replaced.
