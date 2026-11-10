Input: a function `inner` with an expando property assigned `null`/`undefined`, under --strict.
Clean: no errors. Injected: spurious TS7005 "Variable 'prop' implicitly has an 'any' type" on each
assignment (the isInJSFile guard was removed), and exit status 2.
