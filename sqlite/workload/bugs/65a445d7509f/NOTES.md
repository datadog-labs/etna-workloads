repro.sql runs the decimal-2001 query: decimal_cmp() on equal-valued pairs ('-0' vs '+0', '-000.000' vs '0', '1.2' vs '1.2000').
Clean shell: no rows (all compare equal). Buggy shell: all three pairs are returned because the negative-zero sign
normalisation and trailing-fractional-zero trimming were removed, so decimal_cmp() returns nonzero.
