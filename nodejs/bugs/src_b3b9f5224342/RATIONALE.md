# src: fix process exit listeners not receiving unsettled tla codes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b3b9f5224342c366ece5f24618410baa8110c6b3 applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix process exit listeners not receiving unsettled tla codes

fix listeners registered via `process.on('exit', ...` not receiving
error code 13 when an unsettled top-level-await is encountered in
the code

PR-URL: https://github.com/nodejs/node/pull/56872
Fixes: https://github.com/nodejs/node/issues/53551
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
