repro.sql casts a zeroblob(100) to BLOB and prints its hex and length (zeroblob-5.4).
Clean: 200 hex zeros, length 100. Buggy: empty hex, length 0, because
sqlite3VdbeMemNulTerminate doesn't expand the zeroblob before copying it.
