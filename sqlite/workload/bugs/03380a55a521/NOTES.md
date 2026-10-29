Reproducer (`repro.sql`): queries `zipfile()` on the crafted archive from zipfile-20.2, where the central directory entry's name/extra fields run past the end of the blob.

- clean: `Error near line 1: zip archive is corrupt`, exit status 1.
- buggy: the bounds check uses ZIPFILE_LFH_FIXED_SZ instead of ZIPFILE_CDS_FIXED_SZ, so the overrun is missed. The query returns a row (`x|33188|312768000|1|A|A|0`) and exits 0.
