# Rationale
File: src/backend/utils/adt/formatting.c, function DCH_from_char, case DCH_DY/Dy/dy.
Traces to the first hunk of fix_impl.patch: the from_char_seq_search() call passes `days` (full names) instead of `days_short`. Since seq_search no longer limits comparison length, abbreviated day names like "Mon" fail to match "Monday", so to_date/to_timestamp with DY errors out.
The DCH_RM/DCH_rm merge hunk was a cleanup (no behavior change) and was not reverted.

Failing oracle case: src/test/regress||horology
