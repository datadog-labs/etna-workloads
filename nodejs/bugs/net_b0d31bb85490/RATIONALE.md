# net: fix setting of value in 'setDefaultAutoSelectFamilyAttemptTimeout'

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b0d31bb85490fdc9cdd4c8704d2e27d54e67d2b6 applied to v26.13.0 (clean).

Upstream commit message:

```
net: fix setting of value in 'setDefaultAutoSelectFamilyAttemptTimeout'

Document describes that the value have to be 10 if passed value to
`setDefaultAutoSelectFamilyAttemptTimeout` is less than 10.
So need to use 10 for 'if' statement and fix typo in document.

Refs: https://github.com/nodejs/node/blob/main/doc/api/net.md#netsetdefaultautoselectfamilyattempttimeoutvalue
PR-URL: https://github.com/nodejs/node/pull/47012
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
```
