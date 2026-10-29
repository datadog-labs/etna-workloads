# Rationale

Fix: cksumvfs verified checksums on any read with iAmt>=512, but partial-page
reads (SQLITE_DIRECT_OVERFLOW_READ) are not whole pages, giving spurious
SQLITE_IOERR_DATA.

The fix hunk (`iAmt>=512 && (iAmt & (iAmt-1))==0` in cksmRead) still applies in
3.54.1, but reverting it alone changes nothing: the same case is covered by a
second path, `cksmDeviceCharacteristics`, which masks off
SQLITE_IOCAP_SUBPAGE_READ so pager.c's sqlite3PagerDirectReadOk() refuses
direct overflow reads. Both are the same defect, so both are reverted.

## Changes (ext/misc/cksumvfs.c)
1. cksmRead: condition (1) back to `iAmt>=512` (reverses the fix hunk; drops the
   power-of-two test for a complete page).
2. cksmDeviceCharacteristics: return devchar unmodified, so the VFS advertises
   SUBPAGE_READ and btree.c issues partial reads of overflow pages through
   cksmRead (the second path covering the same case).

## Oracle failures
test/cksumvfs.test: 1.1 fails with "disk I/O error" (SQLITE_IOERR_DATA reading
the last, partial overflow page of a 5000-byte blob); 1.4 then hits an assert
in cksmCompute (nByte not a multiple of 8) and the run aborts, so 1.5-1.9 also
fail.
