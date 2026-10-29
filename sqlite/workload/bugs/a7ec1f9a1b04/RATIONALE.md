# Rationale

The fix changed `jsonArrayLengthFunc` so that array entries removed by
`json_remove()` were no longer counted. In 3.54.1 JSON is stored as JSONB and
`json_remove()` physically deletes bytes, so the old `JNODE_REMOVE` flag no
longer exists. The equivalent defect is that the array still reports the
removed entries.

## Change (src/json.c, jsonLookupStep, array `[N]` branch)
Removed the call `if( pParse->delta ) jsonAfterEditSizeAdjust(pParse, iRoot);`
after the recursive `jsonLookupStep()`. Without it, the array's header payload
size is not reduced after an element is deleted. `jsonbArrayCount()` then
walks the stale (too-large) payload size and counts removed entries as part of
the array. This reverses the fix's "skip removed entries" accounting: the
removed entries are still counted in `json_array_length(json_remove(...))`.

## Oracle failures
test/json102.test: json102-191 (the case added by the fix:
`json_array_length(json_remove('[1,2,3,4]','$[2]'))` should be 3),
json102-191b, and json102-440/450/460 (-2..-4), which also edit array elements.
