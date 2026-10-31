Patches a module attribute whose value is an "opaque proxy" (every attribute access raises
AttributeError) using `patch(..., new_callable=MagicMock())`.
Clean: mock never reads attributes of the original when new_callable is set, prints `ok`.
Buggy: patch() calls `_is_async_obj(original)` first, which touches the proxy, so
`AttributeError` escapes from test().
