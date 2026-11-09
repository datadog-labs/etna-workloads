Language-service completions for `import {} from "foo/"` in an .mts file, where foo's package.json has `exports: {"./*": "./dist/*.js"}` and only `dist/blah.d.ts` exists.
Clean build suggests `["blah"]`; the injected build (no sibling-dts suffix lookup) suggests `["blah.d"]`.
