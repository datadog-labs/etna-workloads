repro.sql runs with3-6.0: cte1(x,y) is defined with a 3-column SELECT, and cte2 and the outer query both reference cte1.
Clean shell: "table cte1 has 3 values for 2 columns" (the correct error).
Buggy shell: "no such table: cte1" (the walk error from the CTE is ignored, so a spurious, wrong error is reported).
