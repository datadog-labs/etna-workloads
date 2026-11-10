# test_runner: do not crash on stdout that mimics a v8 frame

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d5737262381cb341aeee4e7e959dc25ce4130bdc applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: do not crash on stdout that mimics a v8 frame

The child test process sends framed report messages and raw user stdout
over one pipe, using the bytes FF 0F to mark the start of a frame. User
output can contain those same bytes, so #processRawBuffer could read a
plausible size from stray stdout and hand the bytes to the v8
deserializer. The deserializer then threw. Because the call had no error
handling, the exception aborted the whole test run.

Read the frame before advancing the buffer and wrap the deserialize in a
try/catch. When the read fails, leave the buffer untouched and stop
parsing frames so #drainRawBuffer emits the stray byte as stdout and
rescans for the next real header. This turns a fatal crash into
recoverable stdout and preserves any real frames that follow the stray
bytes.

Fixes: https://github.com/nodejs/node/issues/66164
Signed-off-by: Muhammad Faizan Uddin <faizan.uddin94@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66273
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
