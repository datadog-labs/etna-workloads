# url: create URLPattern result properties in WebIDL order

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 236d7ca9651550e97c6dd0912def94acce562285 applied to v26.13.0 (clean).

Upstream commit message:

```
url: create URLPattern result properties in WebIDL order

Reorder the URLPatternResult and URLPatternComponentResult dictionary
templates, together with their value arrays, to follow the
lexicographical member order required by WebIDL.

Signed-off-by: Archkon <180910180+Archkon@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64733
Fixes: https://github.com/nodejs/node/issues/64732
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
