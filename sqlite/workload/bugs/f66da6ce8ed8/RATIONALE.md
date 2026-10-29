# Rationale

## Changed hunk
`ext/fts5/fts5_index.c`, `fts5MergePrefixLists()`, multi-poslist merge branch:
removed the `if( nTail>0 )` guard around
`fts5BufferSafeAppendBlob(&out, &pHead->aPos[pHead->iOff], nTail)`.

Fix hunk reversed: the fix added `if( nCopy>0 )` before the blob append in the
older two-list merge (`nCopy = nPoslist - iOff`). That code was later rewritten
into the generalized N-way merge, where `nTail = pHead->iter.nPoslist -
pHead->iOff` plays the role of `nCopy` and the same `>0` guard protects the
append. Removing it restores the pre-fix behaviour: an unconditional append of
`nPoslist - iOff` bytes.

On a corrupt poslist `iOff` can exceed `nPoslist`, so `nTail` is negative.
The size check before it (`tmp.n+nTail > nTmp-PADDING`) doesn't catch that. The
negative value is converted to a huge `size_t` in the memcpy inside
`fts5BufferSafeAppendBlob`, giving a buffer overwrite.

## Oracle results
Running `check.sh` on the modified tree, the test file
`ext/fts5/test/fts5corrupt3.test` aborts partway through with a crash/assert,
and the oracle run is reported incomplete. 118 of 2016 cases are reported as
failing, including `fts5corrupt3-35.1`, which is the case the fix's test
hunk added specifically for this bug (a prefix query, `t1 MATCH 'e*'`,
against a deliberately corrupted database loaded via `deserialize`). The
cases after it in the same file (36.x, 37.x, ... 50.x) also show as failing
because the crash in 35.1 prevents the test harness from running the rest of
the file. This matches the bug: the corrupt poslist causes `nTail` (the
reintroduced unconditional copy length) to go negative, which is interpreted
as a huge unsigned length in the blob-append memcpy, overwriting memory
beyond the output buffer and crashing the process.