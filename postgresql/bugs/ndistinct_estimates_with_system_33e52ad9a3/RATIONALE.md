# Rationale

File/function: src/backend/utils/adt/selfuncs.c, estimate_multivariate_ndistinct (varinfo-removal loop after matching).
Traces to the fix.patch hunk at ~line 3987 of the original code. That hunk made system attributes
stay in the remaining varinfos list instead of being dropped.
The loop was restructured since then, so I re-expressed it: for a simple Var on a system attribute
the loop now does `continue` without `lappend(newlist, varinfo)`. This drops the system-attribute
varinfo, so it is no longer counted in the leftover ndistinct estimate. The estimate is then wrong
for GROUP BY with system columns such as ctid.

Oracle case expected to fail: src/test/regress||stats_ext
