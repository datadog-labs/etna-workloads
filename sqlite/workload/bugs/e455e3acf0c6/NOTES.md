repro.sql is a direct translation of fts3corrupt4-36.0. It creates an fts3 table, plants a corrupt merge-hint record in `f_stat`, then runs `INSERT INTO f(f) VALUES('merge=53,216')`.

`.dbconfig defensive off` is needed so the shell lets the script create `f_stat` by hand.

- clean: runs to completion and prints `done` (exit 0).
- buggy: `Error near line 7: out of memory` (exit 1). The corrupt hint's segment count is not capped, so fts3 attempts a huge allocation.
