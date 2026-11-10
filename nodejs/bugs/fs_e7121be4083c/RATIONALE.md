# fs: stop recursive mkdir from retrying ENOENT forever

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e7121be4083c04a69a316970e5490594d2f1542e applied to v26.13.0 (clean).

Upstream commit message:

```
fs: stop recursive mkdir from retrying ENOENT forever

When mkdir() fails with ENOENT, the recursive algorithm assumes the
parent is missing, creates it and retries. On procfs mkdir() keeps
returning ENOENT although the parent exists, and under a concurrent
rmdir() the parent can disappear again, so the retry loop never
terminates: `fs.mkdirSync('/proc/x', { recursive: true })` spins at
100% CPU.

Retry a path that failed with ENOENT only once and report ENOENT the
second time, like the non-recursive call does.

Fixes: https://github.com/nodejs/node/issues/66268
Signed-off-by: marcopiraccini <marco.piraccini@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66340
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
