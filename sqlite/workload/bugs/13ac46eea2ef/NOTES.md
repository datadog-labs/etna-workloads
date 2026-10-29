repro.sql: indexes substr(b,4) and queries `substr(b,4)='ess' COLLATE nocase`.
Clean shell returns rows 3 and 4. Buggy shell skips setting the collation name
when scanning an expression index, so the wrong collation is used and the
result differs (see ./check.sh).
