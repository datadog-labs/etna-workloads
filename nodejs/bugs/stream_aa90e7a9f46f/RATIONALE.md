# stream: fix setting abort reason in `ReadableStream.pipeTo()`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit aa90e7a9f46f52173b6fcc1a7e18f66323bb1387 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: fix setting abort reason in `ReadableStream.pipeTo()`

In 14.2 in the specification, `error` should be signal’s abort reason.
The current behavior seems to assume that only an `AbortError` instance
is given as signal’s abort reason.

Refs: https://streams.spec.whatwg.org/#readable-stream-pipe-to

Signed-off-by: Daeyeon Jeong daeyeon.dev@gmail.com
PR-URL: https://github.com/nodejs/node/pull/44418
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
