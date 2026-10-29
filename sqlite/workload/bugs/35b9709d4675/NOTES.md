repro.sql runs zipfile() on a crafted in-memory zip blob (test zipfile-21.0) whose central
directory entry has a local-header offset of 0xFFFFFFE2 (negative as a 32-bit int).
Clean: "failed to read LFH at offset -30", exit 1.
Buggy: the offset+30 bound check is done in unsigned 32-bit arithmetic and wraps, so the
check passes and the LFH is read out of bounds; the shell segfaults (exit 139).
