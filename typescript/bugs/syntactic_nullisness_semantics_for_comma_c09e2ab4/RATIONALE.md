# Rationale
Hunk: tree/src/compiler/checker.ts, getSyntacticNullishnessSemantics. The fix added `case CommaToken: return getSyntacticNullishnessSemantics(right)` to the binary-operator switch. In today's code the case is grouped with `=`/`??`/`??=`; I removed `CommaToken` from that group, so comma expressions fall through to `Never` again (the original bug).
Final: SUMMARY: 1/6 oracle cases failing (0 fix-added). Failing: predicateSemantics.ts "Correct errors" (missing/extra diagnostics for comma expressions).
