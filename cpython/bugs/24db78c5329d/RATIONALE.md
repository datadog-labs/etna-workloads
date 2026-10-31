# gh-146080 reintroduced

## Change
`Modules/_ssl.c`, `_servername_callback()`, `error:` label: `Py_XDECREF(ssl_socket)` -> `Py_DECREF(ssl_socket)`.

Reverses the only implementation hunk of the fix. When `ssl->owner` (or `ssl->Socket`) is a dead weakref,
`PyWeakref_GetRef` sets `ssl_socket` to NULL and the code jumps to `error:`, where the unconditional
`Py_DECREF(NULL)` crashes.

## Oracle
`ContextTests.test_sni_callback_on_dead_references` fails: it finishes the server handshake on the
internal SSL object after the owner was collected, so the callback runs with `ssl_socket == NULL`.
The run crashes (the check reports an incomplete run), which also takes out the other cases in the file after it.
