# Rationale

## Objects/memoryobject.c — `memory_hash`

This reverses the single implementation hunk of `fix.patch`.

The fix changed:

```c
if (view->obj != NULL && PyObject_Hash(view->obj) == -1) {
    /* Keep the original error message */
    return -1;
}
```

into a version that temporarily bumps `self->exports` around the call to
`PyObject_Hash(view->obj)`:

```c
if (view->obj != NULL) {
    // Prevent 'self' from being freed when computing the item's hash.
    // See https://github.com/python/cpython/issues/142664.
    self->exports++;
    int rc = PyObject_Hash(view->obj);
    self->exports--;
    if (rc == -1) {
        /* Keep the original error message */
        return -1;
    }
}
```

(In v3.15.2 this same guard exists, but written with `FT_ATOMIC_ADD_SSIZE`
instead of plain `++`/`--`, to be safe under free threading.)

`self->exports` is the memoryview's buffer-export refcount; while it is
nonzero, `memory_release`/`PyBuffer_Release` on the view refuses to actually
tear down the buffer. Bumping it around `PyObject_Hash(view->obj)` is what
prevents a reentrant `view->obj.__hash__` from releasing the memoryview (and
freeing its underlying buffer) while `memory_hash` still holds a pointer into
that buffer for the code that follows (`buffer_to_contiguous`,
`hash_memory`/`hash_array`, etc.).

I restored the pre-fix code exactly: removed the `self->exports++`/`--` pair
and the intermediate `rc` variable, going back to directly testing
`PyObject_Hash(view->obj) == -1` in the `if` condition. This is the exact
code the fix hunk replaced, so every changed line traces directly to that one
hunk. With this reverted, a `__hash__` on the referenced object that releases
the memoryview is no longer prevented from doing so, so `memory_hash` goes on
to operate on a buffer that may already have been freed/invalidated.

No other file was touched; this bug exists in exactly one place in v3.15.2
(no second code path covers the same case), so there was nothing else to
revert.

## Oracle result

Running `./check.sh` against the reverted tree fails `test_memoryview`,
including the regression test added by the fix,
`test_hash_use_after_free` (in `BytesMemoryviewTest` and other memoryview
test subclasses): the test expects `hash(mv)` and `mv.__hash__()` to raise
`BufferError` once the reentrant `__hash__` has released/cleared the backing
buffer, but with the guard removed the call proceeds to actually hash the
view's contents against an already-released buffer, so the expected
`BufferError` is not raised. This matches the scenario the fix's test was
written to guard against.
