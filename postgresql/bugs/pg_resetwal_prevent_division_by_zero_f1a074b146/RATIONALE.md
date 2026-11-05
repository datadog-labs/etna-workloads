# Rationale

## Changed hunk
- File/function: `src/src/bin/pg_resetwal/pg_resetwal.c`, `read_controlfile()`
- Traces to the first hunk of fix.patch (`ReadControlFile`, invalid WAL segment size branch).
- The fix replaced `guessed = true;` with `return false;`, so a control file with an invalid segment size (e.g. 0) is treated as corrupt and every value is guessed. I put `guessed = true;` back. The zeroed `xlog_seg_size` is then used as is and `WalSegSz` becomes 0. That causes the division by zero in `main`/`FindEndOfXLOG` (`/ WalSegSz`), and the run no longer goes through the guess-everything path.
- The second hunk of fix.patch (`WalSegSz = ...` in `GuessControlValues`) has no counterpart in today's code. `main` now sets `WalSegSz` from `ControlFile.xlog_seg_size` after reading, so there was nothing to revert there.

## Failing oracle cases (6 of 9)
- 002_corrupted.pl: does not run when control file values were guessed: exit code not 0
- 002_corrupted.pl: does not run when control file values were guessed: matches
- 002_corrupted.pl: processes zero WAL segment size: status
- 002_corrupted.pl: processes zero WAL segment size: stderr
- 002_corrupted.pl: processes zero WAL segment size: stdout
- 002_corrupted.pl: runs with force when control file values were guessed

The test appears to abort when pg_resetwal hits the division by zero, which is why the later cases show as "missing".
