repro.sql runs approx_percentile_cont_with_weight two ways:
1. Weighted median of values 1,2,3 with weights 1,1,10: clean gives 2.9, buggy gives 2.0 (count was hardcoded to 1, so rank was wrong).
2. The all-zero-weight NaN case from aggregate.slt: clean returns NULL, buggy returns inf.
Exit status is 0 for both builds; only the output differs.
