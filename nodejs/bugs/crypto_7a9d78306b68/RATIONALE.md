# crypto: fix checkPrime crash with large buffers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7a9d78306b68b15e06eecbf30370c551da18bd90 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix checkPrime crash with large buffers

Fixes: https://github.com/nodejs/node/issues/56512
PR-URL: https://github.com/nodejs/node/pull/56559
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
```
