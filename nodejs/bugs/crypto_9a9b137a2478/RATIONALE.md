# crypto: fix private SPKI export error

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9a9b137a247890e4e8c865752583d41e8b52301c applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix private SPKI export error

Reject SPKI export of a private asymmetric key with InvalidAccessError
as required by the algorithm export steps. Let wrapKey propagate the
same export failure.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65550
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
