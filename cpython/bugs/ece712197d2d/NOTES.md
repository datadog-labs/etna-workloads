Calls unittest.util.sorted_list_difference with a duplicated tail in one list while the other is empty.
Clean: `([], [1, 2])` / `([1, 2], [])`. Buggy: duplicates kept, `([], [1, 1, 2, 2])` / `([1, 1, 2, 2], [])`.
