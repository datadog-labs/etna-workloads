Reproducer builds a minimal TZif v1 file (2 types, 2 transitions) whose second
transition index is 2, out of range, and loads it with `ZoneInfo.from_file`.

Clean: `ValueError: Invalid transition index found while reading TZif: 2`.
Buggy: the C check is `>` instead of `>=`, so the bad index is accepted and the
debug assertion `ttinfo_idx < self->num_ttinfos` in `load_data` aborts (exit -6).
