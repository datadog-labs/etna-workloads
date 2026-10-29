# Rationale

Fix hunk (src/func.c, substrFunc): added an up-front return (NULL result) when
argv[1] is NULL or (argc==3 and argv[2] is NULL). Version 3.54.1 handles this
with two later, narrower checks instead of the up-front one:

- `if( p2==0 && sqlite3_value_type(argv[2])==SQLITE_NULL ) return;` (removed)
- `if( sqlite3_value_type(argv[1])==SQLITE_NULL ) return;` inside `if( p1==0 )` (removed)

With both removed, a NULL start or length is treated as 0, so
substr('abcdefg',NULL,1), substr('abcdefg',NULL) and substr('abcdefg',1,NULL)
return strings instead of NULL (the pre-fix behavior). NULL first argument
still returns NULL via the existing `z==0` check, as before the fix.

Oracle failures: substr-1.92, substr-1.93, substr-1.94 (return a string rather than NULL, so ifnull gives non-'nil').
