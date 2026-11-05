# Rationale

File/function: src/backend/commands/createas.c, `ExecCreateTableAs`.
Traces to the fix.patch hunks in ExecCreateTableAs that added the `if (into->skipData)` branch calling `create_ctas_nodata` and made rewrite/plan/execute the `else` path.

Reverted: WITH NO DATA (and matview creation, which always sets skipData and then refreshes) once again goes through QueryRewrite and pg_plan_query, and ExecutorStart/Run with NoMovementScanDirection, instead of defining the relation straight from the targetlist. The planner therefore runs during CREATE MATERIALIZED VIEW / CTAS ... WITH NO DATA. The completion tag is also set again. For matviews, RefreshMatViewByOid is called after the executor path. The helpers create_ctas_nodata/create_ctas_internal are left in place but `create_ctas_nodata` is now unused; this is a minimal edit.

Failing oracle case: src/test/regress||matview
