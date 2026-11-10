# Re-introduced bug: loader uses async hooks on the non-hook thread

Before the fix, when async loader hooks (module.register) were registered, the main (non-loader-hook) thread
resolved/loaded ESM through the async hook path, sharing the cache between async and sync (require) loading and
racing, so require(esm) with async hooks broke.

Changes (lib/internal/modules/esm/loader.js):
- `#resolve()`: condition `this.isForAsyncLoaderHookWorker` -> `this.#asyncLoaderHooks` (fix hunk replacing
  `resolve()` that dispatched on `#asyncLoaderHooks` with one that is sync off the hook thread).
- `load()`: same condition change (fix hunk of `load()`).
Result: the main thread again resolves/loads asynchronously via the hook worker for import(), racing with the sync path.

Failing test: module-hooks/test-module-hooks-require-esm (ERR_INTERNAL_ASSERTION thrown, from the
`assert(moduleOrModulePromise instanceof ModuleWrap)` check). es-module/test-esm-loader-modulemap still passes.
