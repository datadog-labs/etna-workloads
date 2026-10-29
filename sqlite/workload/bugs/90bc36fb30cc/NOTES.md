Creates view v2 over table t1, then queries v2 inside a statement with a CTE also named t1.
Clean shell: the view resolves t1 to the real table and prints `1|2`.
Buggy shell: the view's t1 wrongly resolves to the CTE, giving `3|4`.
