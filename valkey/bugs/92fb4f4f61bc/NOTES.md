repro.sh starts a server and runs `COMMAND INFO` for SET, BITFIELD, GET and MSET. It counts how many times "movablekeys" appears in each reply.
Clean build: 0 for all four commands.
Buggy build: SET and BITFIELD are wrongly flagged movablekeys (count 1). GET and MSET are unaffected.
