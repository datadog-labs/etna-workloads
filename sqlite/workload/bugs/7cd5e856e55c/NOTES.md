Reproducer (repro.sql): the select6-12.100 query. A compound subquery (UNION ALL) contains a
subquery with a LIMIT. The flattener must keep SF_Compound when flattening.

Clean shell prints `1` and `3`, exit 0. Buggy shell fails with an assertion in multiSelect
(`p->selFlags & SF_Compound`), exit 134.
