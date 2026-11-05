# Rationale

File: src/backend/optimizer/path/allpaths.c, function generate_orderedappend_paths().
Traces to the single fix.patch hunk there. The fix computes path_fraction from root->tuple_fraction, converting an absolute limit (>= 1.0) to a fraction by dividing by the row estimate. The cheapest_total->rows form is today's version of the childrel->rows form in the patch, and it also removes the accompanying Assert.
I restored the old code, `path_fraction = 1.0 / root->tuple_fraction`, with no conversion and no Assert. For an absolute LIMIT of N rows this gives 1/N, which is a wrong fraction. The cheapest fractional child paths are then chosen for the wrong fraction, so the plans change.

Oracle case expected to fail: src/test/regress||partition_join
