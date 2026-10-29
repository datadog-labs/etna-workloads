repro.sh builds a db file whose t6 schema has CHECK(myfunc(a)) (via writable_schema, since the shell can't define a UDF), then reopens it.
Clean: SELECT works (9) and INSERT fails with "unknown function: myfunc()".
Buggy: schema load fails with "malformed database schema (t6) - no such function: myfunc".
