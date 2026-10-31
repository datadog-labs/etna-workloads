# Rationale

Reverted the `Lib/typing.py` hunk in `_TypedDictMeta.__new__`: removed
`ns_annotations = ns.pop('__annotations__', None)` and restored
`if "__annotations__" in ns: ... own_annotations = ns["__annotations__"]`.
Without the pop, the PEP 563 string `__annotations__` dict stays in the class
namespace passed to `type.__new__`, so it shadows the generated `__annotate__`
and the class reports `{'child': 'int'}` without inherited base annotations.

Not reverted: the `base.__annotate__` -> `base_annotate` hunk (behaviourally identical).

Failing oracle: `test_typing` `test_inheritance_pep563` (plus 3 other failures in the same run);
child `__annotations__` is `{'child': 'int'}` instead of the ForwardRef/base-merged dict.
