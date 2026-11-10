# sqlite: reject plans with unusable virtual table parameters

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cd16dcb82bdbd2dc35c284333be7a2663f309bd9 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: reject plans with unusable virtual table parameters

Return SQLITE_CONSTRAINT from xBestIndex() when a hidden column has
an equality constraint that is not usable at the current point in the
query plan. Accepting such a plan makes xFilter() call rows() with
null, silently dropping rows and returning an empty result, e.g. for
"SELECT DISTINCT * FROM m(t.a) JOIN t ON t.a = m.a". Cost estimates
alone cannot enforce parameter dependencies; rejecting the plan lets
SQLite pick an ordering where the parameter value is available.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: opencode
PR-URL: https://github.com/nodejs/node/pull/66215
Fixes: https://github.com/nodejs/node/issues/66214
Reviewed-By: Guilherme Araújo <arauujogui@gmail.com>
```
