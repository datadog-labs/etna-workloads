repro.sql runs the in7-3.5..3.8 setup (t1(a UNIQUE), t2(b UNIQUE)) and the four queries
with `(t1.a, t2.b) = / IN (...)`. The last query, `(t1.a,t2.b) IN ((1,2))`, returns `1|2` on the
clean shell but no row on the buggy shell: the copied subquery lacks a fresh selId, so the
SubrtnSig logic reuses the earlier subroutine result for (1,1).
