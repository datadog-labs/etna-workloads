# Rationale

## Changed hunk
- File: src/bin/pg_dump/pg_dump.c, function getDefaultACLs()
- Traces to the fix.patch hunk in pg_dump.c that makes the acldefault computation conditional on `defaclnamespace = 0`.
- The code has since moved from buildACLQueries to a direct query. The current query uses `CASE WHEN defaclnamespace = 0 THEN acldefault(...) ELSE '{}' END AS acldefault`.
- I reverted it to call `acldefault(...)` unconditionally.
- Non-global default ACLs (defaclnamespace != 0) can only add privileges. They must be dumped as deltas from an empty ACL.
- With the bug, they are diffed against the hard-wired default ACL instead. The generated GRANT and REVOKE commands are then wrong for schema-specific default privileges.

## Oracle
The oracle run reported 10051 of 13808 cases failing, all in src/bin/pg_dump t/002_pg_dump.pl. I only read the tail of the output, which showed the test_schema_plus_large_objects "should not dump ..." cases failing with "missing". I did not check which cases cover ALTER DEFAULT PRIVILEGES or why so many cases fail, so I can't say how much of that count comes from this change. Full list is in logs/oracle.log.
