Reproducer (repro.sql) is the where2-6.14 case: OR of equalities `a=c OR b=c` where a,b are NOCASE
columns and the indexed column c is BINARY. The OR-to-IN optimization ignores the conflicting
collations. Clean: `aaa bbb`, `x bbb`, `y aaa` (matching the test's expectations); buggy returns no rows at all.
