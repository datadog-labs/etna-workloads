repro.py assigns a `str` subclass key ('x') through a function frame's `f_locals` proxy, where `x` is a real local, then prints the proxy's keys.

- clean: `['obj', 'x', 'proxy']` (the subclass key overwrites local `x`)
- buggy: `['obj', 'x', 'proxy', 'x']` (the non-exact-str key skips the local-variable path and is stored as an extra key, so `x` appears twice)

The unhashable-key TypeError check in repro.py prints the same on both interpreters.
