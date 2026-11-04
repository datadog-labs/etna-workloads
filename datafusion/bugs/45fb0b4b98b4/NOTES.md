repro.sql runs string_agg and percentile_cont as window functions with
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
Clean: cumulative results (a, a,b, a,b,c; percentile 1.0, 1.5, 2.0).
Buggy: evaluate() consumes accumulator state, so each row only reflects itself (a, b, c; 1.0, 2.0, 3.0).
