Adds a column with `DEFAULT (-(-9223372036854775808))` to a table with a row, then reads it.
Clean shell: `real|9.22337203685478e+18`. The buggy shell gets the Mem flags wrong when negating the smallest int64 (flags `&= MEM_Int` instead of resetting to Real), so the result differs (wrong type/value or assertion failure).
