# Re-introduced bug (upstream 7535aa1f72ac, nodejs/node#59519)

## Bug
Without async loader hooks, ESM load+translate and linking was done through promises
(`async loadAndTranslate`, always-async `#asyncLink`) instead of synchronously. Module jobs
were therefore created/cached before loading finished, so a failed load left a rejected job
in the shared load cache, and later imports of the same URL+type attribute hit that cached
job (racy, and wrong error such as ERR_IMPORT_ATTRIBUTE_TYPE_INCOMPATIBLE instead of
ERR_IMPORT_ATTRIBUTE_UNSUPPORTED).

## Hunks
1. `lib/internal/modules/esm/loader.js` `loadAndTranslate` (fix hunk: `async loadAndTranslate` -> sync/maybe-promise):
   now always an async IIFE (`await this.load(...)` then translate), so it always returns a Promise,
   and a synchronous load error becomes a rejection of a cached job. Also added `PromiseResolve` import.
2. `loader.js` `#getOrCreateModuleJobAfterResolve`: the assertion that a ModuleWrap is returned
   outside the hook worker is limited to the two sync request types (otherwise it would fire).
   Corresponds to the module_job constructor change (module no longer available synchronously).
3. `module_job.js` `link()`: uses `#asyncLink` whenever `this.module` is not yet available
   (always, now, for ordinary imports) rather than only on the hook worker; removed the
   worker-only assert in `#asyncLink`; wrapped `dependencyJobPromise` in `PromiseResolve` since
   `getOrCreateModuleJob` may return a job synchronously. Corresponds to the fix's
   `isPromise(moduleOrModulePromise)` handling in the ModuleJob constructor (module set synchronously).

## Failing tests
`es-module/test-esm-import-attributes-errors` (the .js variant; the .mjs one is also listed under the same name):
```
AssertionError: Expected values to be strictly deep-equal:
+ actual: code 'ERR_IMPORT_ATTRIBUTE_TYPE_INCOMPATIBLE'
- expected: code 'ERR_IMPORT_ATTRIBUTE_UNSUPPORTED'
```
Failed stably in two runs. `test-esm-error-cache` still passes.
