repro.sql: DISTINCT over a zeroblob(5) and x'0000000000' (OP_Found compares unexpanded zero-blob). Clean returns 'xyzzy' and X'0000000000'; buggy returns the zero blob twice (duplicates not removed).
