# Rationale (gh-123270, zipp 3.20.1)

All changes are in `tree/Lib/zipfile/_path/__init__.py`, reversing the fix's hunks:

- Re-added the `SanitizedNames` mix-in (name sanitization in `namelist()`) and put it back in
  `CompleteDirs(InitializedState, SanitizedNames, zipfile.ZipFile)`. This reverses the fix's removal.
- `_ancestry` loop condition restored to `while path and path != posixpath.sep:`
  (fix changed it to `while path.rstrip(posixpath.sep):`), and removed the doctest the fix added for it.

## Failing oracle cases
- `test_malformed_paths`: iterdir yields sanitized names instead of `['../']`.
- `test_unsupported_names`: `V: NMS.flac` is mangled to `V/ NMS.flac`.
- `test_backslash_not_separator`: `foo\bar` is turned into `foo/bar`, a directory.
