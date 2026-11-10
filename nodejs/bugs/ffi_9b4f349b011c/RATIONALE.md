# ffi: refresh cached string buffers on every call

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9b4f349b011c96e268e20dbe2339207e3a3d8b41 applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: refresh cached string buffers on every call

Native code can mutate temporary string storage during an FFI call.
Rewrite cached buffers on every conversion so a later call with the
same JavaScript string receives a fresh copy of its UTF-8 bytes.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65051
Fixes: https://github.com/nodejs/node/issues/65050
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
