# debugger: fix event listener leak in the run command

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9495906f8b17d6db3b849a6bd8c8f2d2ef9ee09e applied to v26.13.0 (fuzzy).

Upstream commit message:

```
debugger: fix event listener leak in the run command

It should remove both the error and the ready event listeners
attached when either of them fires, instead of removing only
the one whose corresponding event fires, otherwise the other
event listener will always get leaked.

PR-URL: https://github.com/nodejs/node/pull/60464
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```
