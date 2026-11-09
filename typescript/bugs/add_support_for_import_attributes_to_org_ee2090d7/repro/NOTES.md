Input has three imports from "./mod": two with `with { type: "json" }` and one without. The script runs the language service's organizeImports and prints the result.
Clean: imports with different attributes are kept separate (json ones coalesced into one, plain one kept separate).
Injected: attributes are ignored when grouping, so all imports get merged into one declaration, dropping/misapplying the attributes.
