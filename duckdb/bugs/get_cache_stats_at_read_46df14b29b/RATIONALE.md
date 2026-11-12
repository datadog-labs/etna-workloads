# Rationale
Hunk: src/storage/external_file_cache/caching_file_system.cpp, CachingFileHandle::ReadAndRecord.
Removed the post-read `GetCacheValidUntil(*handle)` + `TightenCacheDeadline(validation_info.cache_valid_until, ...)` block
(traces to the fix's ReadAndRecord hunk). Cache deadline/prohibition reported by the read response is no longer
picked up, so blocks are cached although the response forbids reuse (original bug, issue 24474).
Other fix hunks (FileSystem::GetCacheValidUntil, Stats, ReconcileCacheAfterRead) are left intact since they are inert without this call.

## etna-check
FAIL cpp:test/common/test_external_file_cache.cpp::Waiter on a loading block refetches when the response prohibits sharing
     test_external_file_cache.cpp:1192 :: policy_fs->GetReadCount() == 2 1 == 2
FAIL cpp:test/common/test_external_file_cache.cpp::Content response can prohibit cache reuse
     test_external_file_cache.cpp:1249 :: CountCachedBlocks(cache) == 0 1 == 0
2 of 37 oracle units fail
