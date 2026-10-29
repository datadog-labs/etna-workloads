Creates a 1024-byte-page table whose single row (4000 hex chars) spills onto overflow pages, then
queries dbstat. The clean shell reports pgoffset 0,1024,2048,3072,4096 for pages 1-5; the buggy shell
computes pgoffset for overflow pages from a stale page number, so the overflow rows show wrong offsets.
