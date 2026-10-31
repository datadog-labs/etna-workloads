Reproducer for gh-138479: a `__typing_subst__` that returns a non-tuple while unpacking
(`type_alias[evil][0]`). Clean build raises `TypeError: expected __typing_subst__ of ... to return a tuple, not int`.
The buggy build skips the PyTuple_Check and reads tuple items from an int (crash/garbage/assert).
