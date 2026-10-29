Reproducer for the VACUUM temp-database bug (fix: PAGER_CACHESPILL on the vacuum temp db).

repro.sh builds a ~700KB file DB (page_size=1024, cache_size=50), sets
temp_store=0 and a hard heap limit of 800000 bytes, then runs VACUUM.
Clean shell: the temp db can spill to a temp file, so VACUUM succeeds
(exit 0, count 5000). Buggy shell: the new image stays in heap, so VACUUM
hits the heap limit: "Error near line 7: out of memory" (exit 1).
