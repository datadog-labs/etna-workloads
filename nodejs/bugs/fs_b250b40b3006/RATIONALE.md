# fs: key glob matcher cache by platform

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b250b40b3006ce07c98e9778b200c3b3c1bc1717 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: key glob matcher cache by platform

Glob matchers capture the path platform when they are created. Include
the platform in the cache key so path.posix and path.win32 do not share
incompatible matchers for the same pattern.

Signed-off-by: Archkon <180910180+Archkon@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64571
Fixes: https://github.com/nodejs/node/issues/64570
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
```
