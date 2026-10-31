Folds a Subject of 12 'ą' with max_line_length=20 (test_non_ascii_chars_do_not_cause_inf_loop).
Clean: returns the folded header with one RFC 2047 encoded word per line.
Buggy: `_fold_as_ew` loops forever (the shrink step uses len(excess) in characters, not bytes, and never makes progress), so the script hangs/times out.
