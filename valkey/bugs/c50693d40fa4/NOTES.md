Reproducer: LPUSH list, then SORT BY nosort STORE (with and without LIMIT) and LRANGE the result. Clean keeps native list order (5 3 4 1 2 / 5 3 4); buggy forces ALPHA sort (1 2 3 4 5 / 1 2 3).
