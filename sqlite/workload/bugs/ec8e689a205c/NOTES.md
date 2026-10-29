`repro.sql` builds an fts3 table, adds a shadow table `f_stat` holding a crafted corrupt blob (needs `.dbconfig defensive off` to create it), then runs `INSERT INTO f(f) VALUES('merge=69,59')`.

- clean: `Error near line 5: database disk image is malformed` (exit 1)
- buggy: no error (exit 0). The corruption check on `iAbsLevel` in `sqlite3Fts3Incrmerge` is missing, so the merge continues with a bogus level.
