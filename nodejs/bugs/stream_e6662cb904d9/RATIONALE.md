# stream: fix Utf8Stream flush handling

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e6662cb904d98d1d716cca9a4c37af35eeda7911 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix Utf8Stream flush handling

Fix several issues with `Utf8Stream` flushing:

* `flush()` now writes buffered data regardless of `minLength`
  and invokes the callback only after pending writes complete,
  including when `minLength` is zero and a write is in flight.
* Multiple concurrent `flush()` calls are tracked correctly and
  `end()` waits for pending flushes before closing.
* `flushSync()` throws `ERR_INVALID_STATE` if called while an
  asynchronous write is in progress instead of corrupting output.
* Periodic flushes no longer stack up while a flush is pending.
* `fsync` is skipped for stdout/stderr file descriptors.
* `reopen()`, `end()` and `destroy()` behave correctly when the
  stream is destroyed while still opening.

Signed-off-by: James M Snell <jasnell@gmail.com>
Assisted-by: Opencode
PR-URL: https://github.com/nodejs/node/pull/66473
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
