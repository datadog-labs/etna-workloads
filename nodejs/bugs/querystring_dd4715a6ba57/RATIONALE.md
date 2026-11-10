# querystring: fix value decoding after encoded keys

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dd4715a6ba5741889346b70a907f4017f885c871 applied to v26.13.0 (clean).

Upstream commit message:

```
querystring: fix value decoding after encoded keys

In the non-default parse() path, a key with more than one percent
escape could corrupt non-ASCII characters in its value.

Keep key characters out of the value's encoding check.

Assisted-by: claude:opus-5.5
Signed-off-by: vedchaudhari <vedc2853@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66553
Refs: https://github.com/nodejs/node/pull/66175
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
