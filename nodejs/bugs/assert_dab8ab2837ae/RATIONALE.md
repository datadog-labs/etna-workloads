# assert,util: compare RegExp.lastIndex while using deep equal checks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dab8ab2837ae80b29678d882f2514b987e6764a0 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
assert,util: compare RegExp.lastIndex while using deep equal checks

Compare the `lastIndex` property of regular expressions next to the
flags and source property.

Fixes: https://github.com/nodejs/node/issues/28766

Signed-off-by: Ruben Bridgewater <ruben@bridgewater.de>

PR-URL: https://github.com/nodejs/node/pull/41020
Reviewed-By: Michaël Zasso <targos@protonmail.com>
Reviewed-By: Richard Lau <rlau@redhat.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
Reviewed-By: Anto Aravinth <anto.aravinth.cse@gmail.com>
```
