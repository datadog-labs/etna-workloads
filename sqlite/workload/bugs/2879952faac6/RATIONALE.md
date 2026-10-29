# Rationale

Hunk reversed: `ext/misc/zipfile.c`, zipfileUpdate() (fix hunk @@ -1337).
The fix made `iCrc32 = crc32(0, aIn, nIn)` run for every non-compressed-method-error
row. Before the fix it ran only inside the `if( bAuto || iMethod )` branch, so
rows stored uncompressed (method 0 explicitly, or auto where deflate did not
shrink... actually only when method=0 given) kept iCrc32 == 0. In 3.54.1 the
code was restructured (extra braces already existed), so I moved the crc32 call
back inside `if( bAuto || iMethod )`, right after zipfileDeflate().

Note: with bAuto, the branch is entered, so auto-method rows still get a CRC;
explicit method 0 rows (the "uncompressed files" case) store crc32 = 0.

Oracle: zipfile-1.4.1 (crc32!=0 for each file) and the unzip-based tests fail
because the stored CRC is 0 for uncompressed entries.
