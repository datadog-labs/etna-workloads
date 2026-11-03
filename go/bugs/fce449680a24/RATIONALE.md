# Rationale

Fix (CL 440455) added `walkStmtList(sinit)` after ordering the generated init code in `fixedlit`, so the code is desugared before being appended to the parent init.

In go1.27.3 that code was refactored: `fixedlit` (src/cmd/compile/internal/walk/complit.go, ~line 249) now does `appendWalkStmt(init, orderStmtInPlace(as, ...))`, i.e. order then walk. I changed it to `init.Append(orderStmtInPlace(as, ...))`, which orders but omits the walk — the pre-fix behaviour.

Oracle: test/fixedbugs/issue56105.go fails with a compiler crash. The walk-less init is also hit while building the runtime (`runtime/metrics.go: internal compiler error: 'initMetrics': unhandled expr CLOSURE`). This is the same symptom the fix guards against: unwalked code reaching the backend.
