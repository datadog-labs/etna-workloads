repro.sql runs `cardinality` on ragged nested arrays ([[1],[2,3]], [[1,2,3],[]], [[],[1,2]]).
Clean build returns 3, 3, 2 (actual leaf count); buggy build multiplies inferred dims and returns 2, 6, 0.
