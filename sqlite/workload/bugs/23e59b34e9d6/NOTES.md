Reproducer: repro.sql calls concat_ws() with an empty-string argument (and a NULL).
Clean shell keeps the empty string: `1,2,3,4,,6,7,8,9,10,11,12` and `,3`.
Buggy shell skips empty strings, giving `1,2,3,4,6,7,8,9,10,11,12` and `3`.
