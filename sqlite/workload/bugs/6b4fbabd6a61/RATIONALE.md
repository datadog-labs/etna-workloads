# Rationale

Fix hunk reversed: the single implementation hunk in `fts5IndexMergeLevel()` (ext/fts5/fts5_index.c).
The fix moved the "key annihilation" `continue` below the term-change check, recorded the new term
in `term` before it, and used a `bTermWritten` flag so the term is appended to the output only once
something is actually output. Version 3.54.1 still contained that fixed code verbatim, so the
pre-fix ordering was restored:

- Removed the `bTermWritten` variable and its uses.
- Moved the annihilation check (`nPos==0 && (bOldest || bDel==0)` -> `continue`) back above the
  term comparison.
- Restored the term-change block: break on `pnRem`, then `fts5WriteAppendTerm()` and
  `fts5BufferSet()` there.

Effect: a term whose first entries are all annihilated is skipped before `term` is updated, so a
partial merge (`pnRem`, as in 'usermerge'/'merge' steps) may stop mid-term and save state for a
term that was only partly processed, corrupting the index.

Oracle result: `fts5delete-1.2` fails (the merge / integrity-check loop); the other cases pass.
