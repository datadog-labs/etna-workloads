# Rationale

**File/function:** src/backend/parser/gram.y, rule `CreateStatsStmt`.

**Traces to:** the gram.y hunk in fix_impl.patch. The fix split the rule into two alternatives, `CREATE STATISTICS ...` and `CREATE STATISTICS IF_P NOT EXISTS ...`. I reverted the rule to a single alternative, `CREATE opt_if_not_exists STATISTICS ...`, with `if_not_exists = $2` and the `$N` positions shifted by one.

**Why this brings the bug back:** the grammar accepts the misplaced `CREATE IF NOT EXISTS STATISTICS name ...`. It rejects the documented `CREATE STATISTICS IF NOT EXISTS name ...`.

In today's code the name is `opt_qualified_name`, so I kept that and only restored the `opt_if_not_exists` position.

**Failing oracle case:** src/test/regress||stats_ext
