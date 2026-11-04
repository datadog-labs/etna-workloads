Reproducer for regexp_count with an empty pattern (and the `start` offset).
Clean build counts empty matches (`regexp_count('abc','')` = 4, start=2 -> 3, start=4 -> 1, start=5 -> 0).
Buggy build returns 0 for an empty pattern in every case.
