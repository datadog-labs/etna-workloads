# Re-introduced bug: default 'timeout' listener not removed on upgrade/CONNECT

On an upgrade or CONNECT, the HTTP server and client hand the raw socket to user code
but leave their own default `'timeout'` listeners attached (server: `socketOnTimeout`;
client: `req.timeoutCb`). A socket timeout after the handoff still triggers HTTP logic.

## Hunks
- `lib/_http_server.js` (onParserExecuteCommon, upgrade/CONNECT branch): removed
  `socket.removeListener('timeout', socketOnTimeout);` (fix hunk in `_http_server.js`).
- `lib/_http_client.js` (socketOnData, upgrade branch): removed
  `if (req.timeoutCb) socket.removeListener('timeout', req.timeoutCb);` (fix hunk in `_http_client.js`).
  The unrelated `responseOnTimeout` removal that was added later is kept.

## Failing test
`parallel/test-http-connect` fails (stable over runs):
`AssertionError: Expected values to be strictly equal: 1 !== 0` at test-http-connect.js:39
(`socket.listenerCount('timeout')` on the server side).
