Builds an FTS4 table, optimizes it into one segment, then (defensive off) moves
it to level 2 and rewrites its end_block to a plain integer (no size, as an old
FTS version would write). A following insert flushes a new level-0 segment.
Clean: the size-less segment is not promoted (`2|0|8`, `0|0|11 2808`).
Buggy: it is wrongly promoted to level 0 (`0|0|8`, `0|1|11 2808`).
