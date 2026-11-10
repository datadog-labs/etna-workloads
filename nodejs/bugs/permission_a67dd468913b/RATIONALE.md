# RATIONALE (CVE-2026-48936, a67dd468913b)

## Bug
Unix-domain-socket pipe operations were not fully guarded by the `net` permission scope. Under `--permission` without `--allow-net`, a pipe could be bound (creating the socket file on disk) and chmod'ed, so permission-restricted code could create and modify socket files.

## Changes (src/pipe_wrap.cc only)
1. `PipeWrap::Fchmod`: removed the `THROW_IF_INSUFFICIENT_PERMISSIONS(env, kNet, "")` check and the now-unused `Environment* env = wrap->env();`. This corresponds to the fix's only implementation hunk (it added both lines). Reversing it alone builds fine, but the test still passes, because `Bind` is guarded.
2. `PipeWrap::Bind`: removed the existing `THROW_IF_INSUFFICIENT_PERMISSIONS` before `uv_pipe_bind2`. This is not a hunk of the fix. The test in this tree already asserts that the socket file does not exist after a denied `listen`, and with only hunk 1 reverted it still passed. Hunk 2 is therefore an addition beyond the literal fix, made so that the oracle test fails. The `Open` guard was left untouched.

## Failing test
`parallel/test-permission-net-uds` gives `not ok` on repeated runs (2 runs after the final build):
`AssertionError [ERR_ASSERTION]: Missing expected exception.` at test-permission-net-uds.js:41, the `net.createServer().listen(path)` assertion. With hunk 1 alone the test passes.
