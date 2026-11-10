# Re-introduced bug: dns.setServers() crashes on port 0

**Bug.** `SetServers` in `src/cares_wrap.cc` validated the family and port with
`CHECK(x->Int32Value(ctx).FromJust())`. That asserts on the *value* being non-zero, not on its type.
A port of `0` (valid, meaning "default port" for c-ares) therefore aborts the process with an assertion failure.

## Hunks
1. `src/cares_wrap.cc`, the two CHECKs: reverted `CHECK(familyValue->IsInt32())` and `CHECK(portValue->IsInt32())`
   to `CHECK(...->Int32Value(env->context()).FromJust())`. This is the fix's first two changes, reversed. Port 0 now fails the CHECK.
2. `src/cares_wrap.cc`, `fam`/`port` extraction: reverted `int32_t x = v.As<Int32>()->Value()`
   to `int x = v->Int32Value(env->context()).FromJust()`. This is the fix's second pair of changes, reversed.
   Needed so the file matches the old code. The plain reversal built fine for this hunk; the tree already compiled.
3. `lib/internal/dns/utils.js` (not part of the fix, needed to expose the bug). Today's JS layer
   maps an explicit port `0` to 53 via `|| IANA_DNS_PORT`, so the C++ code never saw 0 and the old defect was unreachable from
   the public API. I replaced that with a NaN-only default (`NumberIsNaN(port) ? IANA_DNS_PORT`) in both the `[v6]:port` and
   `addr:port` branches. Port 0 now reaches C++, which is how the old code was exercised. Deviation: this hunk has no
   counterpart in the fix diff.

## Failing test
`parallel/test-dns` fails on both runs (the new port-0 case, `dns.setServers(['4.4.4.4:0', ...])`):
```
Assertion failed: portValue->Int32Value(env->context()).FromJust()   (src/cares_wrap.cc:2163)
severity: crashed, exitcode: -6
```
