# Re-introduced bug: dns unsigned record values

c-ares reports TTL, SOA serial and SOA minttl as unsigned 32-bit values. Passing them to `Integer::New` (signed int32) makes values >= 2^31 wrap negative (or come out wrong) in JS.

## Changes (src/cares_wrap.cc, all `Integer::NewFromUnsigned` -> `Integer::New`)
The code has since been refactored to fill `values[]` arrays, so the fix's hunks map as follows:
- AddrTTLToArray ttls (line ~206) <-> fix hunk 1 (AddrTTLToArray).
- ParseSoaReply serial / minttl (~809, ~813) <-> fix hunks 2-3.
- QueryAnyWrap A ttl (~1163) <-> fix hunk 4.
- QueryAnyWrap AAAA ttl (~1243) <-> fix hunk 5.
- QuerySoaWrap serial / minttl (~1719, ~1723) <-> fix hunks 6-7.

## Failing test
`parallel/test-dns` fails: e.g. `minttl: -961633963` vs expected `3333333333`, `serial: -1083979642` vs expected `3210987654`, and ttl wrong for A records. Verified stable across two runs.
