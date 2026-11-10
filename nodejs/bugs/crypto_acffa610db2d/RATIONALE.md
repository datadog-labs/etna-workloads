# crypto: reset random caches across snapshots

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit acffa610db2d85c81d01545194d99fb67920d309 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: reset random caches across snapshots

Startup snapshots retain unused randomInt() and UUID cache entries,
causing deserialized processes to replay the same random values.

Clear the caches after user serialization callbacks and before user
deserialization callbacks. The latter also handles caches refilled by
microtasks, next ticks, or exit handlers after serialization callbacks.

Refs: https://hackerone.com/reports/4059814
Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
PR-URL: https://github.com/nodejs-private/node-private/pull/987
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Ruy Adorno <ruy@vlt.sh>
CVE-ID: CVE-2026-106074
```
