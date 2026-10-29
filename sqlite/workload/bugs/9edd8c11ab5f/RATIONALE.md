# Rationale

## Change: src/vdbe.c, OP_SeekLT/LE/GE/GT (table-cursor branch)

Reverses the fix's `src/vdbe.c` hunk. In 3.54.1 the non-numeric P3 case reads
`if( (newType & MEM_Null) || oc>=OP_SeekGE ){ jump_to_p2 } else { BtreeLast; goto seek_not_found }`.
I restored the pre-fix code: when P3 cannot be converted to any number, always jump to P2.
This is equivalent to the old code. The other lines of the old hunk (the `else` structure and
whitespace) have already been restructured in 3.54.1 and need no change.

The effect is that `SeekLT`/`SeekLE` on an intkey table with a text or blob key (non-numeric)
finds no rows instead of positioning at the last row. Text and blobs sort after all numbers,
so `rowid < 'abc'` should match every row.

## Oracle cases that fail (test/rowid.test)
- rowid-11.desc.3, rowid-11.desc.4: `rowid<'abc'` and `rowid<='abc'` with ORDER BY DESC return `{}` instead of all 8 rows.
- rowid-14.2: `x < 'a' ORDER BY rowid DESC` returns `{}` instead of `{100}`.
