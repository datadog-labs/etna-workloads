# lib: fix AsyncResource.bind not using 'this' from the caller by default

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 409c594887b077701ce69e2959445049b84aaa50 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
lib: fix AsyncResource.bind not using 'this' from the caller by default

PR-URL: https://github.com/nodejs/node/pull/42177
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
Reviewed-By: Bradley Farias <bradley.meck@gmail.com>
Reviewed-By: Bryan English <bryan@bryanenglish.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
