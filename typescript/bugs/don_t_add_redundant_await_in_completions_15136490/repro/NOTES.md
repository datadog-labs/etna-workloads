Completions at `await x(1).|` where x returns Promise<Foo>; the "foo" entry gets insertText `(await x(1)).foo`.
Clean: replacementSpan covers the whole `await x(1).`; injected: only `x(1).`, leaving a redundant `await`.
