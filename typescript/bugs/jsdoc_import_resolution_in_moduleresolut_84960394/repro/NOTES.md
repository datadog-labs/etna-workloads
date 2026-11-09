A JS file uses a JSDoc `/** @import * as tslib from "tslib" */` with `module: preserve` (bundler resolution) and a package whose `exports` has `import`/`module` conditions.
Clean: resolves the module, no errors (exit=0).
Injected: the @import tag isn't used as the resolution context, so it reports TS2307 "Cannot find module 'tslib'".
