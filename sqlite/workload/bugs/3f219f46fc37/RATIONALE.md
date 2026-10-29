# Rationale

Fix hunk reversed: `sumFinalize` in src/func.c, where the fix added
`else if( p->cnt>0 )` so that SUM() of only NULLs yields NULL.

In 3.54.1 the equivalent guard is `if( p && p->cnt>0 )` in `sumFinalize`.
I changed it to `if( p )`, so a context that exists but has seen no non-NULL
input (cnt==0) returns integer `iSum` (0) instead of NULL. This is the
pre-fix behaviour: SUM() of all NULLs returns 0.
(SUM of no rows still returns NULL here, since p==0; that was already the
modern behaviour and isn't part of this bug.)

Oracle failures: test/func.test func-18.4 and func-18.5 (sum over a table
holding only NULLs returns 0, expected NULL).
