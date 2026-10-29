repro.sql is the rowvalue6 test in SQL: a vector IN (subquery) over an index on (a,b) where the subquery yields a row containing NULL.
Clean prints only `400` (the NULL row must not match). The buggy shell's output differs (see ./check.sh).
