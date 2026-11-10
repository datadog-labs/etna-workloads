# Re-introduced bug: missing ERR_REQUIRE_ESM_RACE_CONDITION

Bug: when require() hits an ES module that is cached but not yet fully instantiated (e.g. a concurrent import() in flight), the loader hits an internal-assertion path (`assert.fail("Unexpected module status ...")`) and throws `ERR_INTERNAL_ASSERTION` instead of the public `ERR_REQUIRE_ESM_RACE_CONDITION`.

Hunks (the error definition and the `!job.module` throws are left in place; the release's code differs from the fix's context, so only the status-check hunks were reverted):
- lib/internal/modules/esm/loader.js (`importSyncForRequire`): fix replaced `assert.fail(...Unexpected module status...)` with `assert(status === kUninstantiated)` + `throw new ERR_REQUIRE_ESM_RACE_CONDITION(...)`. Reverted to `assert.fail(`Unexpected module status ${status}.`)`.
- lib/internal/modules/esm/module_job.js (`runSync`): fix replaced `assert.fail(...)` with assert + throw ERR_REQUIRE_ESM_RACE_CONDITION. Reverted to `assert.fail(...)`.

Failing test: es-module/test-esm-require-race-condition — AssertionError: actual code 'ERR_INTERNAL_ASSERTION', expected 'ERR_REQUIRE_ESM_RACE_CONDITION'.
