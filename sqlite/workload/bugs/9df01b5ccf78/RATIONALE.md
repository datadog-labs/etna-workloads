# Rationale

## src/json.c, jsonEachPathLength()
Fix hunk reversed: the fix replaced the old computation of the first-row
json_tree.path length (subtract the payload size of the value, +2 if the path
ends in `"`, then scan back to `.`) with a scan on the path text that handles
`"` labels. In 3.54.1 the function had been rewritten to use jsonLookupStep()
to find the parent, which covers escapes. I restored the old computation
(`]` -> scan back to `[`; otherwise `n -= sz` using jsonbPayloadSize of p->i,
then scan back to `.`). The sz is the length of the unescaped payload, not the
raw path text, so escapes in the path argument give a wrong length.

## Oracle failures
json502-4.1 (`json_tree('{"\u0017":1}','$."\x17"')`) hits the assertion
`sz<n` in jsonEachPathLength (without asserts it would compute a wrong path);
the run aborts, so json502-5.x are reported as failing too (incomplete run).
