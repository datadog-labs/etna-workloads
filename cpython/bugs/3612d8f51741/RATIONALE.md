# Rationale

Fix hunk reversed: `Lib/tarfile.py`, `_get_filtered_attrs`, the hunk that added
```
normalized = os.path.normpath(member.linkname)
if normalized != member.linkname:
    new_attrs['linkname'] = normalized
```
and made the link-target `realpath` use the normalized name (gh-135034, "Normalize link targets").

In v3.15.2 the surrounding code was rewritten (`link_dir`, `normalized` used when building `target_path`).
I removed the normalization and the `linkname` attr, and build `target_path` from the raw `member.linkname`, as before the fix.
Link targets are no longer normalized, so the filter's realpath check and the link actually created can disagree (`a/../..` style targets).

The other fix hunks (`ALLOW_MISSING`, ntpath/posixpath, the extractall rework) are left alone.

## Oracle cases that fail (test_tarfile.TestExtractionFilters)
- test_normpath_realpath_mismatch: LinkOutsideDestinationError not raised
- test_exfiltration_via_symlink
- test_parent_symlink
- test_chmod_outside_dir
