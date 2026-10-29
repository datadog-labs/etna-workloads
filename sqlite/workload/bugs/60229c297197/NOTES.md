`repro.sql` calls json_remove on a 5-element array with path indexes >= 2^32
(`$[4294967296]`, `$[4294967297]`, `$[42949672960]`).
The buggy shell accumulates the index in a u32, which wraps around. It removes
element 0, 1 and 0 respectively. The clean shell finds nothing and returns the
array unchanged, `[0,1,2,3,4]`.
