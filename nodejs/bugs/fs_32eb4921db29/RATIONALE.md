# fs: call the callback with an error if writeSync fails

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 32eb4921db2993b579bc801399038610c1edb5e8 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: call the callback with an error if writeSync fails

Catch SyncWriteStream write file error.

Fixes: https://github.com/nodejs/node/issues/47948
Signed-off-by: killagu <killa123@126.com>
PR-URL: https://github.com/nodejs/node/pull/47949
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
