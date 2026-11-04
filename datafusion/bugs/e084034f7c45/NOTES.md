Reproducer: builds a table with bigint[] values including interior and trailing empty lists, then runs `array_any_value` on it (List and LargeList).

Clean: empty lists give NULL. Buggy: the trailing empty list reads out of bounds, so the CLI panics (exit 101) with "range end index 4 out of range for slice of length 3".
