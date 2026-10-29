repro.sql runs `sum(a) OVER (ORDER BY a ROWS BETWEEN UNBOUNDED PRECEDING AND 0 PRECEDING)` over a small table (window6-11.3.3).
Clean shell returns the running sums with column `a` populated (10|10, 15|25, ...).
Buggy shell deletes rows from the frame too early, so column `a` comes back empty (|10, |25, ...).
