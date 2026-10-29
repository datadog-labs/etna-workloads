# Rationale

## Change

`ext/misc/zipfile.c`, function `zipfileGetEntry()`: removed the bounds check

```c
if( (iOff+ZIPFILE_CDS_FIXED_SZ)>nBlob ){
  /* Not enough data for the CDS structure. Corruption. */
  return zipfileCorrupt(pzErr);
}
```

that guarded the `aBlob!=0` branch before computing `aRead = (u8*)&aBlob[iOff]`.

This reverses the implementation hunk of the fix in `ext/misc/zipfile.c`
(the hunk that added this exact check and dropped the preceding
`(void)nBlob;` no-op). Without the check, `zipfileGetEntry()` sets `aRead`
to point `iOff` bytes into the in-memory zip image `aBlob` with no
verification that `ZIPFILE_CDS_FIXED_SZ` (46) bytes are actually available
from that offset to the end of the buffer. The caller (`zipfileLoadDirectory`,
via `zipfileReadEOCD`'s central-directory offset taken from a
(possibly corrupt/malicious) end-of-central-directory record) then reads the
CDS fixed fields out of `aRead`, over-reading past the end of `aBlob` when
`iOff` is near/at/beyond `nBlob`. This is the same buffer-overread class of
bug the fix addresses, restored at the same call site and by the same
mechanism the fix removed (not a different/invented bug).

The `(void)nBlob;` statement was not restored since `nBlob` is still read by
other, unrelated bounds checks later in the same function (lines checking
`iOff + ZIPFILE_CDS_FIXED_SZ + nFile + nExtra`, etc.) that the fix's commit
did not touch and that remain valid/necessary; removing those would be an
unrelated, invented change, and leaving `(void)nBlob;` out does not change
behavior since the variable is otherwise used.

No other file/path covers this same defect, so no secondary revert was
needed.

## Verification

`./check.sh` build succeeds. Of the 145 oracle cases in `test/zipfile.test`,
13 fail, starting with `zipfile-20.0` — the test case the fix itself added:

```
do_catchsql_test 20.0 {
  SELECT * FROM zipfile(X'504b050600000000010001004000000000a3e1110000');
} {1 {database disk image is malformed}}
```

Instead of returning the expected error, the crafted blob (a 46-byte EOCD
record whose central-directory offset points past the end of the 23-byte
blob) causes `zipfileGetEntry()` to read out of bounds, and the test run
aborts (the harness reports "incomplete run: crash, assert or timeout" for
the remaining downstream cases `zipfile-20.1` through `zipfile-26.3`, which
never get to execute because of the overread/crash). This matches the bug
the fix guards against: a buffer overread in the zipfile extension when
parsing an in-memory zip image with a corrupt/malicious directory offset.
