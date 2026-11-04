`repro.sql` runs log/power calls with a nullable base column (one row has a NULL base) that the simplifier can rewrite: `log(a,1)`, `log(a,a)`, `log(a,power(a,b))`, `power(a,0)`, `power(a,log(a,b))`.

df-clean returns NULL for the NULL-base row in every column. df-buggy drops the nullable base during simplification and returns 0.0, 1.0, 2.0, 1.0, 2.0 for that row. The printed table has different values and different column widths.
