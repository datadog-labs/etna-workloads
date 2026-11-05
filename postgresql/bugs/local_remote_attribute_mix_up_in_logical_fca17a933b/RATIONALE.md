# Rationale

## src/backend/replication/logical/worker.c, slot_modify_data()
Traces to the fix.patch hunk in worker.c (slot_modify_cstrings, `values[i]` -> `values[remoteattnum]`).
slot_modify_cstrings no longer exists; its successor slot_modify_data has the same loop.
Local attribute index `i` and remote attribute number `remoteattnum` are different when column
order differs or columns are dropped. I changed `&tupleData->colvalues[remoteattnum]` to
`&tupleData->colvalues[i]`, so the value is read with the local index while the colstatus check
uses the remote index. This is the same local/remote mix-up. Updates then apply the wrong column's
value (or hit a protocol error).

## Failing oracle cases
25 of 38 fail, all in src/test/subscription t/001_rep_changes.pl. The first failure aborts the
script, so later cases show as missing. Examples: "update works with different column order and
subscriber local values", "update works with dropped publisher column", "update works with dropped subscriber column", "update transmits large column value".
