Language-service script: file with `type foo = any; declare const foo: any;`, completions at position 0 (start of file, where the
location token has no parent), then getCompletionEntryDetails for "foo".
Clean: prints the display parts of the entries. Injected: isConstTypeReference(location.parent) is called with undefined parent,
so it throws (script prints "threw TypeError").
