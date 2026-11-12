# Rationale

The fix's code (GeometryStats::CheckZonemap in geometry_stats.cpp) now lives in `IntersectsExtentFilterPrune`
in src/function/scalar/geometry/geometry_functions.cpp. The fix's one hunk added "FILTER_ALWAYS_TRUE with
nullable stats -> NO_PRUNING_POSSIBLE". Today's code has that check as `column_stats->CanHaveNull() || HasEmptyGeometry()`.

Hunk: removed the `column_stats->CanHaveNull() ||` part of the condition in the `ContainsXY` branch, so a column
that may contain NULLs yields FILTER_ALWAYS_TRUE again and the filter is pruned, letting NULL rows through.
(The empty-geometry check is a separate later addition and is left in place.)

Oracle result (./bin/etna-check):
FAIL test/sql/types/geo/geometry_stats_prune_null.test:48 -- Wrong result: 1000 <> 900
1 of 1 oracle units fail
