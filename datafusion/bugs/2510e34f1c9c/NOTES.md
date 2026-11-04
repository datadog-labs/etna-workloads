Reproducer for the LimitPushdown bug (`satisfied` flag not reset when a nested limit is met).

`repro.sql` cross-joins a 5-row table with a subquery `select unnest([1,2,3]) limit 1`, under an outer `limit 10`.
The outer limit sets `satisfied = true`, and the buggy build keeps that flag when it reaches the inner limit.
It then drops the inner `LIMIT 1`, because the unnest plan can't take a fetch.

The correct result is `count(*) = 5` (clean build). The buggy build returns 10.
