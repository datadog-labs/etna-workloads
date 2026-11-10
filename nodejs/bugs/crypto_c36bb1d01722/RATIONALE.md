# crypto: fix Argon2 validation errors

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c36bb1d01722e1403b651da842dc20713daaf876 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix Argon2 validation errors

Report the correct parameter name for invalid optional inputs.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64852
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
