Input: `subTitle:\nexport const title: string` (an `export` inside a labeled statement, which is invalid syntax), queried through the language service with `getDocumentHighlights` on `export`.
Clean: returns normally (prints the result, which is empty or has no highlights for the modifier).
Injected: the container kind (LabeledStatement) hits `Debug.assertNever`, so the call throws "Invalid container kind." and the script prints `threw: ...`.
