Input: `function Z(){}; Z.foo = 42; class Z {}` (invalid class/function merge with an expando member); repro.sh calls the language service's getNavigationTree on it.
Clean: prints the navigation tree (class Z with constructor and foo, then second Z).
Injected: the missing `n.parent === undefined` guard in isOwnChild makes it crash (or produce a different tree), so the output differs.
