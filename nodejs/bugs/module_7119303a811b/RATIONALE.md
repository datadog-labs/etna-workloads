# module: fix bad `require.resolve` with option paths for `.` and `..`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7119303a811b7f8ab5bebdaa8df4cc81f002dede applied to v26.13.0 (fuzzy).

Upstream commit message:

```
module: fix bad `require.resolve` with option paths for `.` and `..`

this change fixes `require.resolve` used with the `paths` option
not considering `.` and `..` as relative

Fixes: https://github.com/nodejs/node/issues/47000
PR-URL: https://github.com/nodejs/node/pull/56735
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Jordan Harband <ljharb@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
