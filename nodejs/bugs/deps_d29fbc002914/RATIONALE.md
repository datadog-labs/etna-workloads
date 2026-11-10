# deps: fix integration issues with the latest nghttp2

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d29fbc002914e2e1128161b842bfe44ed1909fd4 applied to v26.13.0 (clean).

Upstream commit message:

```
deps: fix integration issues with the latest nghttp2

This is a set of src & tests fixes for nghttp2 due to changes in
v1.67.0+ which require a selection of changes to how we handle
low-level protocol errors when using the latest versions of nghttp2,
changing both some src error handling and updating some tests to match.

Signed-off-by: Tim Perry <pimterry@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/62891
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Stephen Belanger <admin@stephenbelanger.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
