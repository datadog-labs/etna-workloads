Restores the fuzzer-found zset payload (one member with a NAN score) with checksum validation skipped.
Clean: restore fails with "Bad data format", server stays alive (PONG).
Buggy: the NAN check in rdbLoad is missing, so zslInsert asserts and the server crashes (ping fails, ASSERTION printed).
