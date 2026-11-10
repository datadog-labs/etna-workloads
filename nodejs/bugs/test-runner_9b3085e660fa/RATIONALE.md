# test_runner: fix quote escaping in JUnit

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9b3085e660fa38a6f89d3c3872e37917a020cbba applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: fix quote escaping in JUnit

Escape XML content before replacing double quotes and line feeds.

Add a snapshot test for repeated quotes, literal quote references,
and quotes mixed with ampersands, less-than signs, or a newline.

Signed-off-by: hanityx <hanityx@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65971
Refs: https://github.com/nodejs/node/pull/60274
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
