# Rationale

**Bug:** Code mixing top-level await with CommonJS globals (e.g. `require`) in an ES module throws a plain
`ReferenceError: require is not defined in ES module scope`, instead of the `ERR_AMBIGUOUS_MODULE_SYNAX`
("Cannot determine intended module format because both ... and top-level await are present") error.

**Change (lib/internal/modules/esm/module_job.js only):**
- Fix hunk 1 (explainCommonJSGlobalLikeNotDefinedError gained `hasTopLevelAwait` param and an early branch that
  sets the ambiguous message/code): removed the parameter and the whole branch (today's version also had a
  per-global advice switch), so the function always appends ' in ES module scope'.
- Fix hunks 2 and 3 (both call sites, in ModuleJob.run and ModuleJobSync.runSync, pass `this.module.hasTopLevelAwait`):
  reverted to pass only `(e, this.module.url)`.
The C++ `hasTopLevelAwait` support is left untouched (in the release it is a property, not part of the defect).

**Failing test:** es-module/test-esm-detect-ambiguous ("not ok", stable across 2 runs): the ambiguous-syntax
tests expect the "Cannot determine intended module format..." ReferenceError but get
"require is not defined in ES module scope".
