Row-value comparison `(a,b)>(0,0)` on an INTEGER PRIMARY KEY column picks the wrong seek opcode in the buggy build (wherecode.c aMoveOp index).
repro.sql runs `(a,b)>(0,0)` and `(a,b)<(5,0)`; the clean shell returns all 4 rows each time, the buggy one returns wrong rows or asserts.
