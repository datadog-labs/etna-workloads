# Rationale

File: src/backend/access/gist/gistscan.c, function pairingheap_GISTSearchItem_cmp.
Traces to the gistscan.c hunk of fix.patch. The fix replaced the raw `!=`/`<` comparison of
distances with float8_cmp_internal(), which orders NaN and Inf correctly. In today's code
the distances are structs with isnull/value, so the non-null branch was changed back to
`if (a.value != b.value) return (a.value < b.value) ? 1 : -1;`. With NaN, `!=` is always true and
`<` false, so the comparator is inconsistent and the heap order is wrong. (The utils/float.h
include is still needed elsewhere, so it is untouched.)

Failing oracle case: src/test/regress||create_index
