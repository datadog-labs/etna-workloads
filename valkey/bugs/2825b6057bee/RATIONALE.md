# Rationale

Hunk reversed: `src/t_stream.c`, `xautoclaimCommand`, deleted-entry branch of the PEL scan loop. The fix added a `count--;` right after a PEL entry is found to point at a stream entry that no longer exists (it is recorded in `deleted_ids` and the PEL/NACK are cleaned up). That line was unchanged, in the same place, in 9.0.7, so I removed it — an exact reversal of the fix hunk.

Without it, deleted entries no longer count toward COUNT. The `deleted_ids` buffer is sized `count * sizeof(streamID)`, and the loop can now record more than `count` deleted IDs. That overflows the heap buffer (CVE-2022-31144). The reply is also no longer limited by COUNT.

Oracle: "XAUTOCLAIM with XDEL and count" fails. With COUNT 1 it returns the wrong reply, because it claims past the deleted entries instead of stopping at them. The updated "XAUTOCLAIM with XDEL" assertions on the deleted-IDs list can also be affected.
