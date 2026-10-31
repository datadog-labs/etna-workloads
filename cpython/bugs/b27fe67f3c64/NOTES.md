Reproducer: a @runtime_checkable protocol with a non-method member (`x = 1`), with a class registered via `P.register(C)`; then `issubclass(C, P)`.
Clean: raises TypeError ("Protocols with non-method members don't support issubclass()"), because _ProtocolMeta.__subclasscheck__ checks before the ABC cache/registry short-circuit.
Buggy: the check lives only in the protocol's subclasshook, which the ABC registry/cache bypasses, so issubclass returns True.
