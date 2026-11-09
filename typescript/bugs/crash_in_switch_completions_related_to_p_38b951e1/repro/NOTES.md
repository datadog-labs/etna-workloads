Input: `switch (x) { case ('') }` with x: "foo" | "bar"; requests string-literal completions inside the parenthesized case expression via the language service.
Clean: returns ["foo","bar"]. Injected: the case-clause lookup uses the wrong parent (parenthesized expr not skipped), so completions differ (no entries / crash message).
