# Rationale

Changed `type_set_annotations` in `tree/Objects/typeobject.c`: the final
`else { // result can be 0 or 1` is restored to `else if (result == 0)`.
This reverses the single implementation hunk of the fix. `__annotate_func__`
and `__annotate__` are popped only when the last dict operation returned 0, not
when it returned 1 (the cache entry was popped). After `del A.__annotations__`
on a class whose `__annotations__` came from its `__annotate__`, the stale
`__annotate__` survives.

Failing oracle case: `TypeAnnotationTests.test_del_annotations_and_annotate`
(`A.__annotations__` returns `{'a': int}` instead of `{}` after deletion).
