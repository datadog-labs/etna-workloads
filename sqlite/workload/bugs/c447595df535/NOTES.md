Reproducer: LEFT JOIN with an expression index on the right table; WHERE term ifnull(z,0)>=0 must not drive that index. Clean prints 0; buggy prints 1 (wrong result).
