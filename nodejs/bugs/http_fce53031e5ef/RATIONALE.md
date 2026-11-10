# Rationale

**Bug:** `urlToHttpOptions` (used by http(s).request for URL objects) built `options.auth` from the URL's percent-encoded `username`/`password` without decoding, so credentials like `test%40test` were sent as the literal encoded string in the Basic Authorization header.

**Change:** `lib/internal/url.js`, `urlToHttpOptions`: `options.auth = \`${decodeURIComponent(username)}:${decodeURIComponent(password)}\`` became `\`${username}:${password}\``. This corresponds to the single hunk of the fix (line moved/refactored in today's code, with local `username`/`password` variables), and restores the pre-fix undecoded behaviour.

**Failing test:** `parallel/test-http-decoded-auth` reports `not ok` (the server-side assertion on `request.headers.authorization` fails for the percent-encoded cases); stable over two runs.
