Reproducer: `dict.update(obj.__dict__)` where a key's `__eq__` creates another instance
of the same class (sharing the keys object with `obj.__dict__`) and adds an attribute.
Clean: update succeeds, prints `{'a': 'a', 'b': 'b'}`.
Buggy: the mutation check uses `dk_nentries` of the shared keys, so it raises
`RuntimeError: dict mutated during update`.
