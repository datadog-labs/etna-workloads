Language-service script (run.mjs) requests import-statement completions for `import f` with snippet text enabled; another module is named `$foo.ts`.
The completion's insertText contains the module specifier `./$foo`, which needs `$` escaped for snippets.
Clean: `from "./\$foo"`; injected: `from "./\\$foo"` (escaped before quoting, so the escape is doubled).
