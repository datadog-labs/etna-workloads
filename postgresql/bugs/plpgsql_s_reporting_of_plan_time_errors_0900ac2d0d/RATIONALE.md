# Rationale

## src/backend/executor/spi.c, SPI_plan_get_cached_plan()
Traces to the fix.patch hunk adding SPI_plan_get_cached_plan with an
ErrorContextCallback (_SPI_error_callback) around GetCachedPlan. In the original
fix, plpgsql's plan fetches for possibly-simple expressions gained SPI
error-context reporting (the "SQL expression" CONTEXT line). I removed the callback
setup/teardown (spicallbackarg, spierrcontext, push/pop of error_context_stack)
from SPI_plan_get_cached_plan, so plan-time errors raised while (re)planning
simple expressions no longer carry the SQL-expression context, as before the fix.

## Failing oracle cases
- src/test/regress||plpgsql
