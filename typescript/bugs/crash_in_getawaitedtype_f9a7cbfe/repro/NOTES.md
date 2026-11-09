Input: an async generator doing `yield*` over an object whose async iterator's `next()` returns `{ then() {} }` (a thenable with a callable but invalid `then`).
Clean: reports the diagnostic "Type of 'await' operand must either be a valid promise or must not contain a callable 'then' member".
Injected: the specific error-message argument is lost (errorNode misused as diagnostic), so the output differs/crashes.
