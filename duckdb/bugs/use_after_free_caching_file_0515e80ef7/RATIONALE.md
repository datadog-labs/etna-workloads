# Rationale

Re-introduces the use-after-free: CachingFileHandle holds a reference to its CachingFileSystem instead of copying `file_system`/`db` references.

## Hunks
- `src/include/duckdb/storage/external_file_cache/caching_file_system.hpp` (CachingFileHandle members): replaced `FileSystem &file_system; DatabaseInstance &db;` with `CachingFileSystem &caching_file_system;` (fix hunk 1, reversed).
- `src/storage/external_file_cache/caching_file_system.cpp`:
  - constructor: initialise `caching_file_system(caching_file_system_p)` and take `external_file_cache` through it (fix hunk 2).
  - `GetFileHandle`: use `caching_file_system.file_system` for OpenFile and GetValidationInfo (fix hunk 3).
  - `Read`, `ReadUncached`, and the request-sizing setting lookup: use `caching_file_system.db` (fix hunks 4, 5). The sizing lookup is newer than the fix but uses the same member.

The handle now dereferences a dangling CachingFileSystem if it outlives it.

## Oracle result
```
FAIL     cpp:test/common/test_external_file_cache.cpp::A handle can still read after its caching file system is destroyed
1 of 37 oracle units fail
```
Only the new test fails; the others still pass.
