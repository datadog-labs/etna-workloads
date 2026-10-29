repro.sql: a RANGE window with ORDER BY on a column containing NULLs and frame
`1 PRECEDING AND 2 PRECEDING` (or `2 FOLLOWING AND 1 FOLLOWING`), where the start
bound is greater than the end bound.

Clean shell: the NULL-ordered rows (a=1,2) get sum 3, since the NULL peers
are in the frame. Buggy shell: they get NULL, because the injected change applies the
"start>end means empty frame" shortcut to RANGE frames too.
