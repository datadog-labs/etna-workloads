# Re-introduced CVE-2018-12123 (url hostname spoofing via javascript: protocol)

**Bug:** `url.parse()` checked `hostlessProtocol` using the raw (case-preserved) protocol instead of the lowercased one. `javAscript:alert(1);a='@white-listed.com'` was therefore not treated as hostless, so the part after `@` was parsed as a hostname (`white-listed.com`), which allows hostname spoofing.

**Changes (lib/url.js, `Url.prototype.parse`):**
- `if (slashes && !(proto && hostlessProtocol.has(lowerProto)))` -> `has(proto)`. This matches the fix's first hunk, which switched `hostlessProtocol[proto]` to `[lowerProto]`.
- `if (!hostlessProtocol.has(lowerProto) && ...)` -> `has(proto)`. This matches the fix's second hunk.
- Today's code uses a `Set` (`.has`) rather than object indexing, so the hunks are re-expressed with `.has`.

**Failing test:** `parallel/test-url-parse-format` reports `not ok` on two consecutive runs. The mixed-case `javAscript:` cases and the `resolveObject('jAvascript:...')` case produce a parsed auth/host instead of the expected hostless result.
