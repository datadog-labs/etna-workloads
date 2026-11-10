# assert,util: fix deep comparing invalid dates skipping properties

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fc1d6d6b4c6f9c41817de09e7a37543d8067fc57 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
assert,util: fix deep comparing invalid dates skipping properties

The property comparison of invalid dates regressed when starting
to handle invalid dates as being equal.

PR-URL: https://github.com/nodejs/node/pull/61076
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
