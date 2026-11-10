# Re-introduced bug (fix 468fe9eb089c)

**Bug:** a module graph loaded by `require()` (ModuleJobSync) did not record its dependency jobs
(`linked`) so a later `import()` reaching a shared submodule through a different edge walked
`job.linked` as undefined and failed.

**Change (lib/internal/modules/esm/module_job.js, ModuleJobSync constructor):**
`this.linked = this.link(requestType)` became `this.link(requestType)`. This corresponds to the
fix's hunk in ModuleJobSync that collected `linked` jobs (`this.linked = linked`; the
`modulePromise` getter and `getModuleWrapForRequire` returning a job already exist in today's
code in a refactored form, where `syncLink` returns the jobs). Dropping the stored result
restores the old state where sync jobs had no `linked` list.

**Failing test:** es-module/test-require-module-dynamic-import-3:
`TypeError: Cannot read properties of undefined (reading 'length')` (import() after require()).
Test -4 still passes. Failure confirmed in two runs.
