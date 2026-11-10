Input: an arrow function whose only statement returns `{...}[param]` (object literal as leftmost expression).
repro.sh applies the "Remove braces from arrow function" refactor via the language service and prints the result.
Clean: body is wrapped in parentheses, `=> ({...}[param])`. Injected: no parentheses, `=> {...}[param]`, which is invalid code.
