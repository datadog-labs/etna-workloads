# Rationale

Fix hunk reversed: the guard at the top of `FileScanConfig::try_swapping_with_projection`
(`if let Some(inner) = self.file_source.projection() && would_duplicate_...(inner, projection) { return Ok(None) }`).

In 55.2.0 the helper was renamed `would_duplicate_costly_exprs` and extended to also block
multi-referenced non-leaf-pushable ("expensive") expressions. `random()` has `KeepInPlace`
placement, so the volatility check is covered by that second clause as well; the guard
cannot be weakened to "volatile only" without inventing new logic. I removed the call
(the pre-fix state: projection merged into the file source unconditionally) and left the helper
with `#[allow(dead_code)]` so its unit tests still compile. Side effect: the later CSE
guard for expensive expressions is disabled too, since it shares the same call site.

Oracle (`projection_pushdown.slt`) failing: the projection is merged into DataSourceExec, inlining
the aliased expression at every reference (`power(a@0, 2) + b ...` in the CSE case, and `random()`
inlined twice for the volatile case, so `x = y` can be false). The runner reports the failure at
the CSE plan diff (missing ProjectionExec above the scan), line 2171; the volatile test
is the same mechanism.
