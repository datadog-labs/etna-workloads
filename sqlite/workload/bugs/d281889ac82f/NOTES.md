repro.sql runs percentile/percentile_cont/median on a non-numeric input and percentile_disc on an Inf input.
Clean: error messages name the calling function ("input to median() is not numeric", "Inf input to percentile_disc()").
Buggy: messages hardcode "percentile()" ("1st argument to percentile() is not numeric", "Inf input to percentile()").
