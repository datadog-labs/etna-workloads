# Re-introduced bug: fs.rmSync mishandles non-ASCII paths (05d6b9b5)

## Bug
`fs.rmSync` (C++ `RmSync` in src/node_file.cc) built its `std::filesystem::path` from the
raw `ToStringView()` and formatted the EISDIR message from `file_path.c_str()` instead of using
`BufferValue::ToPath()` (correct UTF-8 -> native conversion). Non-ASCII paths were mishandled.

## Changes (src/node_file.cc, RmSync only)
1. Fix hunk `auto file_path = path.ToPath();` -> reverted. On Linux the literal pre-fix
   `std::filesystem::path(path.ToStringView())` behaves identically to `ToPath()`, so the plain
   reversal did not fail any test. To bring back the defect (path conversion that is wrong for
   non-ASCII), the path is built by widening each byte to a code point (`std::u32string`), which
   is correct for ASCII only and mangles multi-byte UTF-8 characters; the file is then "not found"
   and rmSync silently returns without removing it.
2. Fix hunk `THROW_ERR_FS_EISDIR(isolate, "...%s", path)` -> restored to `file_path.c_str()`
   (the pre-fix form). This branch is mostly shadowed by the JS-side check in
   lib/internal/fs/utils.js, so it is not what makes the test fail.

## Failing test
`parallel/test-fs-rmSync-special-char` fails (stable over 2 runs):
`AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: true !== false`
at test line 21 (`fs.existsSync(filePath)` still true after `fs.rmSync(filePath)`).
