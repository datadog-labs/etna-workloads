repro.sql: creates a table with a DESC index on x, then runs min(x) and max(x).
Clean shell prints 1 then 20; buggy shell prints 20 then 1 (min/max swapped,
because the min/max optimization no longer inverts the scan for a descending index).
