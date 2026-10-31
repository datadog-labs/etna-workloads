Reproducer: `class A(List[int], NonType())` where `NonType` is a non-type instance whose
`__mro_entries__` returns `(Generic,)`.
Clean: prints the MRO `['A', 'list', 'Generic', 'object']`.
Buggy: `_GenericAlias.__mro_entries__` calls `issubclass()` on the non-type base and raises
`TypeError: issubclass() arg 1 must be a class`.
