Reproducer: switches EXPLAIN to the `indent` format (the CLI default `tree` format
does not explain physical-planning errors), then runs EXPLAIN on a CROSS JOIN LATERAL
whose subquery cannot be decorrelated, so physical planning fails with
"Physical plan does not support logical expression OuterReferenceColumn".

Clean build: the EXPLAIN output has a `physical_plan_error` row with the error message.
Buggy build: the error is recorded under the wrong plan type (`initial_physical_plan`)
and the row is not displayed in non-verbose mode, so the output has only the logical plan.
