# util: use a global symbol for `util.promisify.custom`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ba684805b6c0eded76e5cd89ee00328ac7a59365 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
util: use a global symbol for `util.promisify.custom`

Define `util.promisify.custom`
as `Symbol.for("nodejs.util.inspect.custom")`, rather than
as `Symbol("util.inspect.custom")`.

This allows custom `promisify` wrappers to easily/safely be defined
in non‑Node.js environments.

Fixes: https://github.com/nodejs/node/issues/31647

PR-URL: https://github.com/nodejs/node/pull/31672
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Gus Caplan <me@gus.host>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
```
