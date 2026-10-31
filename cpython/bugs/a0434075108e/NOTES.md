Reproducer: a defaultdict factory that re-enters d[key] on its first call (nested lookup inserts value 2).
Clean: outer lookup keeps existing value -> prints `2 2 {...: 2}`. Buggy: outer overwrites with 1 -> `1 2 {...: 1}`.
