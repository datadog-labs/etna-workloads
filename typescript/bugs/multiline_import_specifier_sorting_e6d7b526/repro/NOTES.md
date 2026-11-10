Input: a file with a multiline `import { b, a, c } from "foo"` (one specifier per line), run through language service `organizeImports`.
Clean: the rewritten import keeps the multiline layout (one specifier per line, sorted).
Injected: the PreferNewLine flag is dropped for the multiline named-imports list, so the output differs (collapsed onto a single line).
