# Rationale

**Bug:** `http2.connect()` with an `http:` authority let the authority's host/port override `options.host` / `options.port` (issue #28182). E.g. `connect('http://foo.bar', {host:'localhost', port})` tried to connect to foo.bar:80 instead of the given host/port.

**Change (lib/internal/http2/core.js, `connect()`, `http:` case):** `net.connect({ port, host, ...options })` -> `net.connect({ ...options, port, host })`. This corresponds to the fix's single hunk (`net.connect(options.port || port, options.host || host)`); today's code spreads options after port/host so options win, and reversing the order makes the authority-derived values win again, as before the fix.

**Failing test:** `parallel/test-http2-connect` ("not ok 1"): the new case connecting to `http://foo.bar` with options host/port tries to resolve foo.bar (connection error / callback never called).
