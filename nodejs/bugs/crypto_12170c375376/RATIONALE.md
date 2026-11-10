# crypto: use user-facing error for output encoding changes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 12170c37537657ea1636acc4001658b2320b8fe7 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: use user-facing error for output encoding changes

Replace the internal assertion with ERR_INVALID_ARG_VALUE when the
output encoding changes between Cipher or Decipher calls. Document the
encoding requirement and update the corresponding tests.

Signed-off-by: Archkon <180910180+Archkon@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64692
Fixes: https://github.com/nodejs/node/issues/64689
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
