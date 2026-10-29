# Rationale

## Change: src/select.c, selectAddSubqueryTypeInfo()
The fix replaced `assert( (p->selFlags & SF_HasTypeInfo)==0 );` with
`if( p->selFlags & SF_HasTypeInfo ) return;`. Version 3.54.1 still has the
early return (same function, same line). I restored the original assert, so a
SELECT visited a second time (a CTE/sub-query containing a window function
whose SF_HasTypeInfo flag is already set, used in a FROM clause of an outer
query that also uses a window function) trips the assertion.

## Oracle failures
window1-9.3 aborts with `selectAddSubqueryTypeInfo: Assertion
'(p->selFlags & SF_HasTypeInfo)==0' failed.` (the test the fix added). Test 9.2
passes. Cases after 9.3 do not run because of the abort.
