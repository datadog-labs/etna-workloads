Reproducer (repro.sql) binds ?1..?4 via `.parameter set`, then runs a statement mixing
numbered (?1) and unnumbered (?) parameters with `.trace stdout --expanded`, which prints
sqlite3_expanded_sql().

Clean: the first `?` after ?4 is parameter 5 and the last is 6 (both unbound -> NULL):
  SELECT 'A' || 'A' || 'B' || 'C' || 'D' || NULL || 'A' || NULL;
Buggy: nextIndex is reset to idx+1 after the trailing ?1, so the last `?` is expanded as
parameter 2 ('B') instead of 6:
  SELECT 'A' || 'A' || 'B' || 'C' || 'D' || NULL || 'A' || 'B';
