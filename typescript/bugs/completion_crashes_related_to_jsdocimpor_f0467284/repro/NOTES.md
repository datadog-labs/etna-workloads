Input: a JS file with `/** @import { MyUnion } from "" */` (empty module specifier), and the language service is asked for completions inside the quotes.
Clean: getCompletionsAtPosition returns normally (prints an empty entry list).
Injected: the binder no longer binds the JSDocImportTag's moduleSpecifier/attributes, so completions crash with "Cannot read properties of undefined (reading 'kind')".
