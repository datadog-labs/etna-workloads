# Re-introduced bug: double ERR_PROXY_TUNNEL emission

**Bug.** When establishing an HTTPS proxy tunnel fails, the `ERR_PROXY_TUNNEL` error was delivered
to the user's request twice: once by the proxy logic in `handleSocketAfterProxy` (lib/_http_agent.js)
and once by the generic socket-destroy path in `ClientRequest` (lib/_http_client.js).

## Hunks
1. `lib/_http_client.js` (`_destroy` in the socket-close path, fix hunk 2): removed the
   `err.code !== 'ERR_PROXY_TUNNEL'` exclusion, so `emitErrorEvent(req, err)` also fires for tunnel errors.
   The release had an extra `!socket?._hadError` condition (added later); it is kept as is.
2. `lib/_http_agent.js` (`handleSocketAfterProxy`, fix hunk 1): put `req.emit('error', err)` back
   into an `else` branch, so tunnel errors that are not timeouts are emitted only there. This matches
   the pre-fix code layout (fix hunk 1 reversed directly).

Tested final tree has both hunks applied.

## Failing tests
All four oracle cases fail with the change, since their assertion expects exactly one match of
`ERR_PROXY_TUNNEL ... Failed to establish tunnel` in stderr (`.length === 1`) and now finds two.
They pass on the clean release. Note: the tests must be run with the sandbox's `*_PROXY`/`NO_PROXY`
environment variables unset, otherwise they fail even on a clean tree (server hit directly).
