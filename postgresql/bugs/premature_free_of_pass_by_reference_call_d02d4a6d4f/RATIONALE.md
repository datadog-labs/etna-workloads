# Rationale

File: src/backend/commands/functioncmds.c, function ExecuteCallStmt (the one changed hunk).

Traces to the fix.patch hunk that replaces the per-argument `CreateExecutorState()` / `CreateStandaloneExprContext()` / `FreeExecutorState()` with a single EState and ExprContext. The EState is created before the argument loop and freed only after the procedure returns.

In the current code the single EState is already created before the loop. I put the bug back by creating a fresh EState and ExprContext inside the per-argument loop, shadowing the outer ones. Each EState is freed right after its argument is evaluated, before the procedure is invoked. Pass-by-reference argument values live in that EState's memory context, so they are freed prematurely. Procedures that COMMIT, or otherwise reuse the arguments, then see freed memory.

Failing oracle case: src/test/regress||create_procedure
