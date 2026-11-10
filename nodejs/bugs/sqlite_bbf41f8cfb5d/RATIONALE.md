# sqlite: persist enableDefensive() across reopen

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bbf41f8cfb5df64073ff681757a42eda8eb3a2d2 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: persist enableDefensive() across reopen

`enableDefensive()` updated only the live connection, so after
`close()` and `open()` the defensive flag went back to the value
passed to the constructor. Store the new value in the open
configuration so that `open()` applies it again.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66404
Fixes: https://github.com/nodejs/node/issues/66403
Reviewed-By: Guilherme Araújo <arauujogui@gmail.com>
```
