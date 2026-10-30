repro.sh: creates a stream+group, delivers 5 entries to a consumer, XDELs 3 of them, then runs `XAUTOCLAIM ... COUNT 2`.
Clean: deleted PEL entries count toward COUNT, so the reply has next cursor 3-0, no claimed entries, deleted ids 1-0 2-0.
Buggy (missing `count--`): cursor 0-0, claims 4-0 and 5-0 as well, and reports all three deleted ids.
