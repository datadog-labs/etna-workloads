Input: a class with a private field `#x` assigned through parentheses on the left, `(obj.#x) = 2` and `((obj.#x)) += 3`, compiled with target es2015.
Clean: the parentheses are skipped, so the assignments lower to `__classPrivateFieldSet(...)` calls.
Injected: the parenthesized left side isn't recognized, so the output keeps the invalid `(obj.#x) = 2` form instead of lowering it.
