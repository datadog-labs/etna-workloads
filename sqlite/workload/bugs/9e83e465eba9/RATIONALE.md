# Rationale

Changed only `fts3PromoteSegments` in `tree/ext/fts3/fts3_write.c`, reversing the
promotion hunk of fix.patch (the other hunks are already in place in 3.54.1 and left alone):

- `bOk = 0` -> `bOk = 1`, and drop the `bOk = 1;` inside the loop: pre-fix code
  assumed promotion was OK even when no higher-level segment exists.
- `nLimit = (nByte*3)/2` -> `nLimit = nByte`: pre-fix limit had no 50% slack.
- `if( nSize<=0 || nSize>nLimit )` -> `if( nSize>nLimit )`: pre-fix code promoted
  segments whose end_block holds no size (nSize==0, written by old FTS).

Failing oracle cases: fts4growth2-1.2 and fts4growth2-1.3 (the index grows
instead of staying at max level 4 with one level-4 segment, because segment
promotion misbehaves).
