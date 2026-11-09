Input has a malformed angle-bracket type assertion with a missing `>` (`<unknown 123;`), checked with erasableSyntaxOnly via the API.
The TS1294 diagnostic span differs: clean covers `<unknown ` (up to the expression start); injected assumes a `>` exists and extends the span by one char past the type (swallowing into `123`).
