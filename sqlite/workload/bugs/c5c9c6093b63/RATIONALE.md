# Rationale

Fix hunk reversed: `cksmDeviceCharacteristics` in `ext/misc/cksumvfs.c`. The fix
masked out `SQLITE_IOCAP_SUBPAGE_READ`; I restored the pre-fix passthrough of
`xDeviceCharacteristics` of the underlying VFS. With the flag visible, the pager
issues sub-page direct-overflow reads that cksmRead() treats as full pages
(power-of-two size >=512) and checksum-verifies, yielding SQLITE_IOERR_DATA.

Other hunks: the `iAmt>=512 && pow2` condition and the added assert are already in
their pre-fix form in version-3.54.1 (the tree still has the pow2 check and no assert),
so nothing to change.

Oracle: cksumvfs-1.4 fails with "disk I/O error" (the direct-overflow read test).
