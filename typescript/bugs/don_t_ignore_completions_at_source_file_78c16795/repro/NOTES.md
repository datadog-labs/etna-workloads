input.ts ends with `var y = x as ` followed by blank lines; run.mjs asks the language service for completions right after `as `.
The completion location is the source file node (EOF), which the injected build no longer handles in shouldIncludeSymbol.
Clean: completions include the type `T` (prints true). Injected: type-only filtering is skipped, `T` is missing (prints false).
