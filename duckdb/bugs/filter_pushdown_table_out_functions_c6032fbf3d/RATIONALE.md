# Rationale

Today's tree already contains the fix, so I re-introduced the bug by undoing one hunk of it.

## Hunk changed
`src/execution/operator/projection/physical_tableinout_function.cpp`, in `GetOperatorState` and `GetGlobalOperatorState`.
This traces to the fix's hunks in the same two functions. They changed
`TableFunctionInitInput input(bind_data.get(), column_ids, vector<idx_t>(), nullptr)` to pass `projection_ids, table_filters.get()`.
I restored the original `vector<idx_t>(), nullptr`. The table in-out function's init_global and init_local no longer receive the pushed filters or the projection ids.
The optimizer still pushes filters into the function, so they are never applied. That is the original bug.

## Not changed
The other hunks of the fix are left as they are: the constructor and header members, the plan_get changes and the pushdown_get changes. Reverting those would have meant a header change and a 40+ minute rebuild.

## Oracle result
```
FAIL     cpp:test/sql/function/table/table_in_out.cpp::Filter pushdown into table in-out functions
PASS     ... Caching TableInOutFunction
PASS     ... Parallel execution with caching table in out functions
PASS     ... Lateral table in out function preserves constant struct fields
PASS     ... Type-limited filters remain above table in-out functions
PASS     ... Correlated filters remain above table in-out functions
PASS     ... WITH ORDINALITY reports unfiltered positions for table in-out functions
1 of 7 oracle units fail
```
Only 1 of the 7 listed oracle units fails, not all 7. The others pass because they keep filters above the function or don't depend on the function receiving them.
The failing test expects `filter_state` = 3, meaning both global and local state received filters. With the bug, the function receives none.
