# src: disable V8 external memory reasonable size check

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6e9d44d1fe03f671b5014877e595379d8e6774df applied to v26.13.0 (clean).

Upstream commit message:

```
src: disable V8 external memory reasonable size check

V8 aborts the process when external memory grows by more than
--external-memory-max-reasonable-size gigabytes in a single step. The
32 GB default is a Chromium-oriented sanity check; allocating a buffer
larger than that is legitimate in Node and should raise a RangeError
rather than terminate the process.

Default the flag to 0 unless the user supplied a value, alongside the
other V8 defaults Node sets explicitly.

Fixes: https://github.com/nodejs/node/issues/65534
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/65589
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
