# Rationale

File: src/backend/executor/nodeAgg.c

1. `build_pertrans_for_aggref` / `ExecInitAgg` caller (combine branch): removed `pertrans->numTransInputs = 1` (fix hunk 2, the combine branch).
2. `ExecInitAgg` (non-combine branch): removed the caller-side numTransInputs computation (fix hunks 1 and 3).
3. `build_pertrans_for_aggref`: restored the unconditional pre-fix computation. `numTransInputs` is `numInputs` for ordered-set aggregates and `numArguments` otherwise, and it is set before the combine/non-combine split (fix hunk 1, reversed).

Effect: when combining (partial aggregation), `numArguments` is 2 (the combinefn takes two args of the transtype). So `numTransInputs` becomes 2 instead of 1, and the combine path treats the aggregate as having the wrong number of inputs. This brings back the bug for aggregates that don't have exactly one argument.

Failing oracle cases: src/test/regress||aggregates (confirmed FAIL).
