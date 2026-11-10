# util: limit `inspect` to only show own properties

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 26b7fd2009c348a64674da78ddda1076e74595d2 applied to v26.13.0 (clean).

Upstream commit message:

```
util: limit `inspect` to only show own properties

`Error`'s `cause` and `errors` properties would be visible even if these
were not own properties. This is changed to align with all other
parts of the `inspect` handling.

Fixes: https://github.com/nodejs/node/issues/60717
PR-URL: https://github.com/nodejs/node/pull/61032
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
