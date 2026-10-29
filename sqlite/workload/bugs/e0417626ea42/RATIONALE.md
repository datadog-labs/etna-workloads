# Rationale

Fix e0417626 (fts3.c `fts3PrefixParameter`) made fts3/4 silently drop prefix
indexes of size 0 (and sizes that overflow, which `fts3GobbleInt` in 3.54.1
clamps to 0 via MAX_NPREFIX).

## Change (ext/fts3/fts3.c, fts3PrefixParameter)
Reverses the fix's second hunk: the `if( nPrefix<=0 ){ nIndex--; i--; }else{...}`
block is removed and `aIndex[i].nPrefix = nPrefix;` is stored unconditionally,
so zero-size prefix indexes are kept again. The fix's first/third hunks (moving
`*pnIndex = nIndex` to the end) are already equivalent here because with no
decrement nIndex is unchanged, so `*pnIndex` is still correct; no edit was needed.
(Note: 3.54.1 already used `nPrefix==0` with an assert rather than `<=0`; negatives
are rejected by the parser, so this is the same.)

## Oracle failures
fts3prefix-6.1.1 (`prefix=0`), 6.2.1 (`prefix="1,0,2"`), 6.5.1
(`prefix="2147483647,2147483648,2147483649"`) fail with "out of memory" at
CREATE VIRTUAL TABLE / INSERT, since a zero-size prefix index is now created.
