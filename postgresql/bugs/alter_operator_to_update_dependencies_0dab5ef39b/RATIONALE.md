# Rationale

Changed hunk: `src/backend/commands/operatorcmds.c`, `AlterOperator()`.

Traces to the fix.patch hunk in `AlterOperator` that replaced `ObjectAddressSet(address, OperatorRelationId, oprId)` with `address = makeOperatorDependencies(tup, true)`. In current code that call is `makeOperatorDependencies(tup, false, true)`. I reverted it to plain `ObjectAddressSet(...)`.

Without the call, ALTER OPERATOR no longer refreshes pg_depend entries. Dependencies on the newly set restrict/join estimator functions, the commutator and the negator are not recorded. Stale ones are not removed.

The other hunks of the fix (the isUpdate parameter and the header split) are refactoring that supports this call. They are left in place, so `makeOperatorDependencies` stays in use by `OperatorCreate`.

Failing oracle case: `src/test/regress||alter_operator`
