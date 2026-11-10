# sqlite: handle thrown errors in result callback

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e201299011153ea68a3a7502827ad8d6196d5a18 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: handle thrown errors in result callback

This commit updates the aggregate function 'result' callback
handling to not crash when an exception is thrown.

Fixes: https://github.com/nodejs/node/issues/58425
PR-URL: https://github.com/nodejs/node/pull/58426
Reviewed-By: Zeyu "Alex" Yang <himself65@outlook.com>
Reviewed-By: Edy Silva <edigleyssonsilva@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
```
