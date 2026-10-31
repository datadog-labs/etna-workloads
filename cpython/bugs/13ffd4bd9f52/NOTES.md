Reproducer: an Enum whose member values are tuples with a falsey second item, then called by value as `Cardinal(1, 0)`.
Clean: prints `<Cardinal.RIGHT: (1, 0)>` and `<Cardinal.LEFT: (-1, 0)>`.
Buggy: `names` (0) is treated as falsey, so the value isn't rebuilt as a tuple and the call fails (ValueError/TypeError).
