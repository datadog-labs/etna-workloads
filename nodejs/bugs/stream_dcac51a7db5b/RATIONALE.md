# stream: align pull() abort handling with the spec

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dcac51a7db5b97e6ee44182a902f3742519e71af applied to v26.13.0 (clean).

Upstream commit message:

```
stream: align pull() abort handling with the spec

pull() threw synchronously when given an already-aborted signal. The
spec (Iterable Streams, Stream.pull() step 5) requires it to return an
iterable that throws the abort reason when read. This also matches how
broadcast.push() and share.pull() already handle a pre-aborted signal.

Once the signal aborted, the pull that observed the abort rejected,
but later pulls resolved { done: true } because the pipeline is an
async generator, which completes after throwing. The spec (step 7)
requires future pulls to reject with the abort reason as well, so
that a stream that was cancelled is never reported as having ended
cleanly.

Return an iterator that rejects every read with the abort reason once
the signal has aborted the pipeline, without starting the pipeline if
the signal was already aborted. Pipelines without a signal are not
affected. The two tests that asserted the synchronous throw now check
the rejection instead, and the documentation is updated.

Assisted-by: OpenCode
Signed-off-by: James M Snell <jasnell@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66483
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
