Input: a generic `parse = <def>(def: validate<def>)` whose parameter type is a conditional/template-literal type; the language service requests string completions inside `parse({ prop: "foo|" })` and `parse("foo|")`.
Clean: completions are the expected `foo|bar`, `foo|baz`, `foo|foo` (plus keywords for the shallow case).
Injected: the second candidate-collection pass (without cached resolved signature) is missing, so the completion lists differ or are incomplete.
