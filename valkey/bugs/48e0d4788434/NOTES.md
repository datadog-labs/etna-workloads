repro.sh starts a server and runs `MSETNX x1 xxx x1 yyy` on an empty db, then `GET x1`.
Clean: GET returns `yyy` (last value wins). Buggy: GET returns `xxx`, because the second setKey
still uses the DOESNT_EXIST flag and so doesn't overwrite the key added by the first pair.
