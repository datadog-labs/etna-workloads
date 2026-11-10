# Re-introduced bug: net.connect()/socket.connect() accept missing args

Bug: `net.connect()`, `socket.connect()` and `connect({})` were treated as a connect with an empty
options object instead of throwing `ERR_MISSING_ARGS` (because `normalizeArgs`, shared with `.listen()`,
accepts empty args). The call silently proceeded and failed later or behaved oddly.

Hunks (both in lib/net.js):
1. Removed `ERR_MISSING_ARGS` from the `internal/errors` destructuring import - reverses fix hunk 1 (now unused).
2. Removed the check `if (options.port === undefined && options.path == null) throw new ERR_MISSING_ARGS(['options','port','path'])`
   from `Socket.prototype.connect` (today it sits after the `_parent?.connecting` early return) - reverses fix hunk 2.

Failing tests with the change:
- parallel/test-net-connect-no-arg: `net.connect()` does not throw; expected ERR_MISSING_ARGS
  ('The "options" or "port" or "path" argument must be specified').
- parallel/test-net-normalize-args: `socket.connect([{port}, fail])` no longer throws ERR_MISSING_ARGS.
