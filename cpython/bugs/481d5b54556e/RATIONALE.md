# Rationale

Fix hunk (Lib/tarfile.py, `makelink_with_filter`): added
`if os.path.lexists(targetpath): os.unlink(targetpath)` before `os.link(...)`
in the hardlink branch.

In v3.15.2 the same lines exist (the `os.link` call now uses
`os.path.realpath(...)`). I removed the `lexists`/`unlink` block, leaving the
`os.link` call and the CVE comment as they were. This restores the pre-fix
behaviour. If the target path already exists (e.g. as a symlink),
`os.link` raises FileExistsError. That is a subclass of OSError, not of
`symlink_exception`, so it is not handled by the fallback path.

Oracle cases that fail: `test_extract_hardlink_on_symlink` and
`test_extractall_hardlink_on_symlink` in MiscReadTest and the Gzip, Bz2 and
Lzma variants (8 in total). The pre-existing symlink is not replaced, and the
content check fails (a digest mismatch).
