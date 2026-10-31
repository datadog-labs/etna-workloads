Function annotation `range[1]` raises TypeError when evaluated. `get_annotations(f, format=FORWARDREF)`
should fall back to a ForwardRef, but with the bug only NameError is caught from `__annotations__`,
so the TypeError escapes (or the result differs) in the buggy interpreter.
