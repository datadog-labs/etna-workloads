# gh-131666 reintroduced

## Objects/iterobject.c (reverses all three fix hunks)
- `anextawaitable_proxy`: always calls `PyObject_CallMethod(awaitable, meth, "O", arg)` (the fix added the `arg == NULL` branch).
- `anextawaitable_close`: takes `args` and forwards them to the proxy instead of passing NULL.
- `anextawaitable_methods`: `close` is `METH_VARARGS` again instead of `METH_NOARGS`.

So `anext_awaitable.close(1)` is accepted by the outer object and the args are forwarded.

## Objects/genobject.c (second path, same defect)
On v3.15.2 the wrapped `coro_wrapper` `close` is `METH_NOARGS`, so the forwarded arguments still produced a TypeError and hid the bug. I put `coro_wrapper_close` back to `METH_VARARGS`. Its C function already takes `args`, and it is the same defect: a `close` method that accepts arguments. The wrapper then swallows the extra argument.

## Oracle
`test_coroutines.CoroutineTest.test_await_17` fails: `anext(A(), "a").__await__().close(1)` no longer raises TypeError.
