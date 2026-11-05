# Rationale

File: src/backend/executor/execSRF.c, function ExecMakeTableFunctionResult (value-per-call branch).
Traces to the fix.patch hunk in execQual.c that removed the "returnsTuple && fcinfo.isnull" error check.
I re-added that check ahead of the first_time block. A NULL rowtype result from a set-returning function
now raises "function returning set of rows cannot return null value" instead of becoming an all-nulls row.
Non-SRFs break out of the loop and get the all-nulls row built at no_function_result.
The later NULL-expansion code is left in place but is unreachable for tuple results.

Failing oracle case: src/test/regress||rangefuncs
