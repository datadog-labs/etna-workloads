# Bug
`res.writeHead(status, undefined, headers)` discarded the headers: when `reason` was not a string, `obj` was unconditionally overwritten with `reason` (undefined), so the headers passed as third arg were lost.

# Change
`lib/_http_server.js` writeHead, else-branch: `obj ??= reason;` -> `obj = reason;`. This is the single hunk of the fix, reversed (line context shifted: `this.statusMessage ||=` is now used).

# Failing test
`parallel/test-http-write-head-2` fails (not ok) on the new case: the response lacks the `foo: bar` header (`res.headers.foo` is undefined rather than 'bar'). Run twice, stable.
