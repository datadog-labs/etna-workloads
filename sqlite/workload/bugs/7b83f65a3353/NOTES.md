repro.sql: a virtual generated FLOAT column holding integer 0, selected through `if(1,b)` in a materialized CTE.
Clean shell prints `0.0|real`; buggy shell keeps the value as IntReal, so it prints a different result (see ./check.sh).
