Reproducer: builds a table with a NULL map row and calls map_keys/map_values on it.
Clean: both return NULL for the NULL row (`IS NULL` is true).
Buggy: both return an empty list `[]` instead (the null buffer is dropped), so `IS NULL` is false.
