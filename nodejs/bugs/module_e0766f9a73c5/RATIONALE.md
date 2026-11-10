# Bug
require(esm) of a cached async module job that is instantiated but not yet evaluated (module graph a.mjs -> b.cjs -> require(c.mjs), while c.mjs is also imported by a.mjs) did not run the evaluation. The loader returned the namespace of an unevaluated module, producing `ReferenceError: module.exports is not defined`.

# Change (lib/internal/modules/esm/module_job.js, ModuleJob.runSync)
Corresponds to the fix's runSync hunk. The fix removed the early `if (this.instantiated !== undefined) return { module }` and made runSync inspect the real module status (evaluating when kInstantiated). I restored the old early return at the top of runSync (today's code otherwise already handles statuses). A job that has started async instantiation (this.instantiated set) is then returned without evaluation, as before the fix. The other fix hunks (debug output, debug_utils MODULE, isGraphAsync binding) are refactoring/support and not needed to bring back the defect.

# Failing test
es-module/test-require-module-instantiated: `not ok` — `ReferenceError: module.exports is not defined` (stable over 2 runs).
