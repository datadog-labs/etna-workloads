# sqlite: throw on oversized strings instead of aborting

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 54867cd25e152daf0ed8d895ea968855ffba3596 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: throw on oversized strings instead of aborting

Several conversions from SQLite text to V8 strings passed a length of
-1 to String::NewFromUtf8(). With that length, V8 skips its length
check and aborts the process when the UTF-8 text exceeds
String::kMaxLength.

SQLite error messages embed the offending identifier or token, so
CreateSQLiteErrorImpl() could hit this. NullableSQLiteStringToValue(),
used for setAuthorizer() callback arguments and statement.columns()
metadata, had the same problem, and the authorizer also called
ToLocalChecked() on each argument.

Convert error messages with Utf8StringMaybeOneByte(), and check the
length up front in NullableSQLiteStringToValue(), so oversized strings
throw ERR_STRING_TOO_LONG as column values already do. In the
authorizer, deny the action and let the pending error reach the caller.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66521
Fixes: https://github.com/nodejs/node/issues/66520
Fixes: https://github.com/nodejs/node/issues/66522
Reviewed-By: Guilherme Araújo <arauujogui@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
