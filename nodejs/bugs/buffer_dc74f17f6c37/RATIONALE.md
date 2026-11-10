# Re-introduce: Buffer.write Fast API disabled (dc74f17f6c37)

## Bug
Before the upstream fix, `Buffer.prototype.{ascii,latin1,utf8}Write` did not use the V8 Fast API
(it had been disabled because of a UTF8 handling bug in the fast path). All calls went through the
slow binding, so `buffer.writeString` fast-API calls never happened.

## Change (src/node_buffer.cc, one hunk)
In `Initialize`, the three `SetFastMethod(... "asciiWriteStatic"/"latin1WriteStatic"/"utf8WriteStatic" ..., &fast_write_string_*)`
calls are replaced by plain `SetMethod(..., SlowWriteString<ENC>)`. This corresponds to the fix's hunk
that changed `SetMethod` -> `SetFastMethod` in `Initialize`. The templated FastWriteString /
WriteOneByteString hunks and external-reference registrations of the fix still exist in the
release and were left intact (they remain registered, just unused), so the build stays valid.

## Failing test
`parallel/test-buffer-write-fast` fails (stable over repeated runs):
```
AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
0 !== 4
    at test-buffer-write-fast.js:48
```
(`getV8FastApiCallCount('buffer.writeString')` is 0 since the fast path is never taken.)
