repro.sql runs `date_part('ISODOW', ...)` / `EXTRACT(isodow ...)` on a DATE and a timestamp (2000-01-01 is a Saturday; 2020-09-08 is a Tuesday).
df-clean returns 6 and 2; df-buggy returns 5 and 1, which is the 0-based Monday=0 value.
Exit status is 0 on both builds. Only the query results differ.
