# Rationale

File: src/backend/statistics/dependencies.c, function clauselist_apply_dependencies().

Traces to the fix.patch hunk that introduced clauselist_apply_dependencies() with the
`if (s1 <= s2) ... else ...` Min(P(a),P(b)) logic. Today's code keeps that function, so I
reverted the conditional-probability computation to the pre-fix formula
`attr_sel[attidx] = f + (1 - f) * s2`, i.e. P(a,b) = P(a)*[f + (1-f)P(b)]. The dependent part
is then no longer capped by the implied column's own selectivity, so the combined estimate
can exceed the column estimate when P(b) < P(a).

Failing oracle case: src/test/regress||stats_ext
