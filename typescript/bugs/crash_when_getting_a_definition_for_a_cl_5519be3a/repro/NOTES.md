Input: class B extends A with `override [k] = 3;` where k is a const string and A declares `[k]`.
The script asks the language service for go-to-definition at the `override` keyword.
Clean: returns the base member's definition `[k]` in A. Injected: the computed name is looked up by its text, so it finds nothing (empty result).
