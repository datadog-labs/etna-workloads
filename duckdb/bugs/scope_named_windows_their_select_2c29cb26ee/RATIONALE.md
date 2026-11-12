# Rationale
Reverted the per-SELECT scoping of named windows (fix 2c29cb26) in the PEG transformer.

- `include/duckdb/parser/peg/transformer/peg_transformer.hpp`, `PEGTransformer::window_clauses`: back from a per-nesting-level container (deque here, vector in the fix) to a single flat `identifier_map_t`. Traces to the header hunk.
- `parser/peg/transformer/peg_transformer.cpp`, `GetWindowClause`: looks up the single flat map, with the old `window \"%s\" does not exist` message. Traces to the GetWindowClause hunk.
- `parser/peg/transformer/transform_select.cpp`, `RegisterWindowClause`: uses the flat map, so duplicate checks and registrations are global. Traces to the RegisterWindowClause hunk.
- `InitializeSimpleSelectTrampoline`: removed `window_clauses.emplace_back()`.
- `FinalizeSimpleSelectTrampoline`: `window_clauses.clear()` replaces `pop_back()`. A nested SELECT therefore wipes the outer SELECT's windows, and inner definitions leak outward. Traces to the Initialize/Finalize hunks.
- `PEGTransformer::Clear()` already clears `window_clauses` here, and it compiles with either container type, so I left it alone.

## Result
```
FAIL     test/sql/window/test_window_clause_scope.test
         test/sql/window/test_window_clause_scope.test:6 :: Query unexpectedly failed
         SELECT (SELECT 1), sum(1) OVER w WINDOW w AS (ORDER BY 1);
         Parser Error: window ""w"" does not exist
1 of 1 oracle units fail
```
