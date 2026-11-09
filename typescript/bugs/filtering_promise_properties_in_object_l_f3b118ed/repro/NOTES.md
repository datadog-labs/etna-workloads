The input calls a function whose callback returns `MyType | Promise<MyType>`, and the callback returns an empty object literal. The script requests completions inside that literal through the language service.
Clean build: the Promise member is filtered out of the contextual type, so completions list only `foo`.
Injected build: the filtering is missing, so Promise members (e.g. `then`) show up as well.
