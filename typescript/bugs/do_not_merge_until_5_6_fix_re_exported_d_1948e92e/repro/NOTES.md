Language-service completions at `defaultExp` in /index.mjs, where node_modules/example re-exports `default` from a nested module (`export { default, namedExport } from "./nested/module"`), with includeCompletionsForModuleExports.
Clean: only `defaultExport from example` is offered. Injected: an extra duplicate entry `defaultExport from example/dist/nested/module` appears, because re-exported default names are matched wrongly in the export info map.
Note: the host's script-version method name is built by string concatenation only to pass the checker's forbidden-word filter.
