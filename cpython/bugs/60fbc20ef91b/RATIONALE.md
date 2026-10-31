# gh-140947 reintroduced

Changed `Lib/asyncio/base_events.py`, `Server._start_serving`: dropped the
`context=self._context` argument to `self._loop._start_serving(...)`.

Reverses the fix hunk `-self._ssl_shutdown_timeout) / +self._ssl_shutdown_timeout, context=self._context)`.
Without it the loop's `_start_serving` receives `context=None`, so the accept
path (`conn_context = None`) never uses the context captured when the server
was created. Connection tasks and transport callbacks run in whatever context
the event loop's reader callback has, not the server's copied context, which is
the pre-fix bug. The rest of the plumbing in v3.15.2 is left intact; it simply
receives None, as before the fix.

Failing oracle case: `test_server_context` (a `test_gh140947` case) fails with
`connection_lost` being `[]` instead of `[('cvar1', True), ('cvar2', True)]`,
i.e. context variables set at server creation are not visible in the handlers.
