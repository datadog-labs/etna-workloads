# src: fix loadEnvFile ENOENT error

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c1d9f426a11eda97e44e2326c66dbf59dfc4084e applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix loadEnvFile ENOENT error

Before this change the error message for `process.loadEnvFile()` without
an `.env` file present in the current working directory was looking like
this: `ENOENT: .env, Failed to load '%s'.` This obviously isn't what the
author intended.

To fix that, just return a "plain" ENOENT open error. It should be
descriptive enough. That means for the above example, the error message
is now `ENOENT: no such file or directory, open '.env'`.

PR-URL: https://github.com/nodejs/node/pull/52438
Reviewed-By: Yagiz Nizipli <yagiz.nizipli@sentry.io>
```
