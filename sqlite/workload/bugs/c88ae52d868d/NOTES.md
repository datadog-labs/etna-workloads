Reproducer (repro.sql): builds TEMP tables t1/t2 (1024-byte pages, cache_size=50) so the temp file is
created and t1's pages are dirty-in-cache, then in a transaction DELETEs t1 (PagerDontWrite on its
leaves) and does a large UPDATE of t2 to evict them, then ROLLBACK.
Clean: final SELECT returns 1,1,1 (t1 content intact). Buggy: returns 1,0,0 (rows 2 and 3 lost their data after rollback).
