# crypto: fix argument validation in crypto.timingSafeEqual fast path

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c9578dc557ef767eb8204a9d0d7731a599213028 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix argument validation in crypto.timingSafeEqual fast path

A regression introduced by
https://github.com/nodejs/node/commit/0136bb0ee807b9789bf69e8d87e7a98e1b15f217
made it possible for the fast path to be hit with non-array-buffer
arguments despite that the fast paths could only deal with array
buffer arguments, so that it can crash with invalid arguments
once crypto.timingSafeEqual is optimized instead of throwing
validation errors as usual. This adds validation to the fast path
so that it throws correctly.

PR-URL: https://github.com/nodejs/node/pull/60538
Fixes: https://github.com/nodejs/node/issues/60537
Refs: https://github.com/nodejs-private/node-private/pull/749
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
