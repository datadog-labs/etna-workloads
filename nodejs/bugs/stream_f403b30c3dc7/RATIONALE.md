# stream: use RangeError for broadcast overflow

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f403b30c3dc7d58f2aacc6eb88b3f3a550ed4526 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: use RangeError for broadcast overflow

Reject strict-backpressure writes with a RangeError when the broadcast
pending writes queue is full.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64420
Fixes: https://github.com/nodejs/node/issues/64419
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
```
