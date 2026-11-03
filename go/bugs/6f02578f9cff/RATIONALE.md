# Rationale

Fix: cmd/compile logopt, "fix logopt log directory naming for windows" (#41614).

The go1.27.3 code already has the fix's `parseLogPath`/`checkLogPath` structure, so
the old `checkLogPath` can't be restored verbatim. The one hunk reversed is the
Windows URI decoding in `parseLogPath` (src/cmd/compile/internal/logopt/log_opts.go):

- Fix hunk: after `destination = uri.Host + uri.Path`, added
  `if isWindowsDriveURIPath(destination) { destination = destination[1:] }`
  to strip the leading `/` from `/C:`.
- Reversed: removed that block, so `file:///c:foo` yields `/c:foo` (the pre-fix
  behaviour, where URI path was used unchanged and was wrong on Windows).
  `isWindowsDriveURIPath` is left in place, now unused.

## Oracle failure
`TestPathStuff` fails: `parseLogPath("file:///c:foo")` returns `/c:foo` instead of
`c:foo`. The other 15 oracle cases still pass.
