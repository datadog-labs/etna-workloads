Writes an uncompressed (method 0) entry via the zipfile virtual table and reads back its CDS crc32.
Clean: crc32 is nonzero (prints `f.txt|1`). Buggy: crc32 is only computed when deflating, so it is 0 (`f.txt|0`).
