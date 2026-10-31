# RATIONALE

Only file changed: `tree/Lib/tarfile.py`, in `_get_filtered_attrs` and `AbsoluteLinkError`.

1. Link target resolution (fix hunk `@@ -802,7 +802,14 @@`). The fix resolves a symlink's target
   relative to the directory containing the link (`dirname(name)`), and a hard link's target
   relative to the archive root. I removed the `member.issym()` branch, so `target_path` is
   again `join(dest_path, normalized linkname)` for both types. v3.15.2 already had the
   `ALLOW_MISSING` realpath and the normalised linkname, so I kept those and removed only
   the symlink-specific `link_dir` computation. This is the same defect as the original.
2. Error message (fix hunk `@@ -742,7 +742,7 @@`). The text is back to
   "is a symlink to an absolute path".

Oracle failures: `test_tarfile` fails with 17 failures and 5 errors, including
`test_extract_filters_target_none`. Symlinks like `a/b/s -> ../escape` are wrongly rejected
as outside the destination, and `data_filter` symlink tests fail. Symlinks that escape via a
subdirectory-relative path are also mis-evaluated.
