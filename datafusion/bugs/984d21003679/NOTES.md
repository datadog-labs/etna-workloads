Reproducer: sort-merge LEFT JOIN (hash join disabled) between t1(a,b) and t2(a,b,c) with an
equality plus a non-equi filter, so the left and right inputs have different column counts.

With the bug, the null-out range for filter-failed rows starts at the buffered column count
instead of (total - buffered), so the wrong column is nulled. df-buggy returns `3 | 300 | 3 | NULL | NULL`
for the last row; df-clean returns `3 | 300 | NULL | NULL | NULL`.
