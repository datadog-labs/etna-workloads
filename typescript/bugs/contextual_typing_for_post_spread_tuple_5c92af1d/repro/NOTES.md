Calls a generic function constrained to a tuple `[string, string, string, 'a' | 'b']` with an array literal `[...t3, 'a']` that has a spread followed by a literal.
Clean: no errors (the element after the spread is contextually typed by the tuple's trailing element, so 'a' stays literal).
Injected: TS2345, the element is inferred as `string` because the post-spread contextual type index is wrong.
