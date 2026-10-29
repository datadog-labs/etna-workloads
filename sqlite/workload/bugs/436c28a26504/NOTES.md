repro.sql runs the join8-25010/25020 setup (page size not needed) and the two FULL JOIN queries.
Clean shell returns `-|-|-|-|-|x` and `1`; the buggy shell returns no rows for both,
because the FROM-clause terms left of a FULL JOIN get reordered (JT_LTORJ check removed).
