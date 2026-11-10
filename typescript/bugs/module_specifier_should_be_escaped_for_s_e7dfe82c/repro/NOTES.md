Language-service script: file `$foo.ts` exports `foo`; `bar.ts` contains `import f`. Requests import-statement completions with snippet text.
Clean: insertText is `import { foo$1 } from "./\$foo";` (the `$` in the module specifier is escaped for snippets).
Injected: insertText is `import { foo$1 } from "./$foo";` (unescaped, which would be read as a snippet placeholder).
