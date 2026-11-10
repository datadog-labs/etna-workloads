# src: report libuv error when openAsBlob cannot stat

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9c46e563034fe1d8806dd275f4a34340b74af5a5 applied to v26.13.0 (clean).

Upstream commit message:

```
src: report libuv error when openAsBlob cannot stat

`FdEntry::Create()` returned nullptr for any failed `uv_fs_stat()`,
discarding the status, and `BlobFromFilePath()` turned that into
`ERR_INVALID_ARG_VALUE: Unable to open file as blob`. A missing file is
not a malformed argument, and the resulting `TypeError` carried no
`errno`, `syscall`, or `path`, so ENOENT could not be told apart from
any other reason the path was unusable.

Thread the libuv status out of `CreateFdEntry()` and throw a
`UVException` instead, so `fs.openAsBlob()` reports the same error
`fs.stat()` does for the same path.

Fixes: https://github.com/nodejs/node/issues/65514
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/65517
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
