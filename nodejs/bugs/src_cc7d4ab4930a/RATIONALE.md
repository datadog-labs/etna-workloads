# src: fix `napi_check_object_type_tag()`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cc7d4ab4930a9d9d70d0d2bdad29f9a9f2ca9320 applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix `napi_check_object_type_tag()`

This fixes a comparison failure occurring when the upper value of a
type tag is 0, or a type tag value is 0.

Signed-off-by: Daeyeon Jeong daeyeon.dev@gmail.com

PR-URL: https://github.com/nodejs/node/pull/43788
Fixes: https://github.com/nodejs/node/issues/43786
Reviewed-By: Michael Dawson <midawson@redhat.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```
