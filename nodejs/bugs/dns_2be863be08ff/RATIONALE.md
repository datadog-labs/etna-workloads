# Bug
The c-ares channel was initialised without the query cache option, so the intended DNS query cache (c-ares `ARES_OPT_QUERY_CACHE`) was never enabled in `ChannelWrap::Setup()`.

# Change
`src/cares_wrap.cc`, `ChannelWrap::Setup()`: removed `ARES_OPT_QUERY_CACHE` from `optmask`. This corresponds to the fix's only implementation hunk, which added that flag. Today's code builds `optmask` with an extra `MAXTIMEOUTMS` step, so the hunk is re-expressed for the current layout.

# Failing test
`parallel/test-dns` fails in two runs: "Mismatched <anonymous> function calls. Expected exactly 8, actual 7." The test expects cases.length*2 server responses, which is the count the fix restored. Without the cache, one fewer query is answered than the test expects.
