# Rationale (ext/misc/zipfile.c, zipfileGetEntry)

The fix's overread checks had been kept in 3.54.1 (with a slightly different
form), so I removed them to restore the pre-fix code:

- Removed the `(iOff + ZIPFILE_CDS_FIXED_SZ + nFile + nExtra)>nBlob` check after
  `aRead = &aBlob[iOff+ZIPFILE_CDS_FIXED_SZ]`. This reverses the fix hunk at
  old line ~861. Without it, the filename/extra memcpy reads past the blob.
- Removed the `cds.iOffset + ZIPFILE_LFH_FIXED_SZ > nBlob` check before
  `zipfileReadLFH(aRead)`. This reverses the fix hunk at old line ~883. Without
  it, the LFH is read past the blob.
- Reverted the three `zipfileCorrupt(pzErr)` calls to plain `return/rc =
  SQLITE_CORRUPT`, as before the fix (no "zip archive is corrupt" message).
  `zipfileCorrupt()` stays defined but is now unused.

## Oracle failures
- zipfile-20.0: gets "database disk image is malformed" instead of "zip archive is corrupt".
- zipfile-20.1, 20.2: the truncated archives are accepted and return rows (the overread) instead of an error.
