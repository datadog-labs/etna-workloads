# Rationale

Bug: auto-generated stream IDs (`XADD key *`) wrapping around on overflow were not rejected.

## Changes (tree/src/t_stream.c)
1. `streamAppendItem`: the fix made the "new ID must be > last_id" check apply to the
   generated ID too (previously only `if (use_id && ...)`). Restored `use_id &&` on the
   check, so an auto-generated ID that wrapped (streamNextID -> 0-0) is accepted.
2. `xaddCommand`: removed the later-added early "stream has exhausted the last possible
   ID" check. It covers the same defect from another path (max-max last_id then `*`),
   so it had to go for the bug to reappear.

## Oracle
`XADD IDs correctly report an error when overflowing` fails: `xadd mystream *` after
`18446744073709551615-18446744073709551615` returns `0-0` instead of an ERR.
