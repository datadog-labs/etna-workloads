# Rationale

Changed: src/bin/pgbench/pgbench.c, `evalStandardFunc()`, cases PGBENCH_ADD / SUB / MUL.

Traces to the fix.patch hunk in evalStandardFunc that replaced `li + ri`, `li - ri` and `li * ri`
with pg_add/sub/mul_s64_overflow checks. I restored the unchecked arithmetic, so 64-bit
overflow wraps silently instead of reporting "bigint add/sub/mul out of range" and failing.

Oracle cases that fail: see the output of agent_oracle.py (the pgbench overflow tests in
t/001_pgbench_with_server.pl that expect the "out of range" errors).

Failing cases (all in src/bin/pgbench t/001_pgbench_with_server.pl): "pgbench script error: set bigint
{add,sub,mul} overflow" status/stderr/stdout (9 cases), plus "transaction count for <P>/001_pgbench_log_3.<N> (10)".
