Language-service completions inside an empty named import `import {  } from "./file"`, where file.ts exports `x as await` and `x as interface`.
Clean: the keyword-named entries get insertText `await as await_` / `interface as interface_`.
Injected: those entries have no insertText (the NamedImports keyword rename was removed).
