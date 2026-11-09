Input: a generic `f<K extends keyof typeof myEnum>(a: K, b: M[K])` called as `f("valA", "")`; the language service requests string completions inside the second argument.
Clean: completions are ["1","2"] (K inferred from the first argument).
Injected: the skip-direct-inference string literal yields wildcardType, so K isn't inferred properly and the completions differ (wrong or missing entries).
