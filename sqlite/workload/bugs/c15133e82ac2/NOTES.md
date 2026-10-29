repro.sql: creates a trigger whose body calls an unknown aggregate-style function with an ORDER BY containing a subquery (group_concat(DISTINCT a ORDER BY a)), then runs ALTER TABLE RENAME.
Clean shell: rename succeeds, schema lists e, r1, t1.
Buggy shell: assertion failure in selectAddSubqueryTypeInfo (SF_Resolved not set), abort (exit -6).
