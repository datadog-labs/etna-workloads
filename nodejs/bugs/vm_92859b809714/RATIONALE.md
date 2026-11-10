# vm: fix copying PropertyDescriptor

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 92859b8097149a3b4cc406bfe71b504af70eb8b5 applied to v26.13.0 (clean).

Upstream commit message:

```
vm: fix copying PropertyDescriptor

This fixes a long-standing issue that
`ContextifyContext::PropertyDefinerCallback` incorrectly copies the
`const PropertyDescriptor& desc`, assigning value to be `undefined` when
no value present on the `PropertyDescriptor`.

This is revealed after https://github.com/nodejs/node/pull/63549 because
returning `kYes` tells V8 that the definer handled it, and V8 no longer
fixes it up.

Signed-off-by: Chengzhong Wu <cwu631@bloomberg.net>
PR-URL: https://github.com/nodejs/node/pull/64073
Fixes: https://github.com/nodejs/node/issues/64008
Reviewed-By: Edy Silva <edigleyssonsilva@gmail.com>
```
