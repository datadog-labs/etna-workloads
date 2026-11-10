# worker: fix --abort-on-uncaught-exception handling

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fd038a1f1556e4d525ffb9ba07b2951e14e81cda applied to v26.13.0 (fuzzy).

Upstream commit message:

```
worker: fix --abort-on-uncaught-exception handling

The `set_abort_on_uncaught_exception(false)` line was supposed to
prevent aborting when running Workers in
`--abort-on-uncaught-exception` mode, but it was incorrectly set
and not checked properly in the should-abort callback.

PR-URL: https://github.com/nodejs/node/pull/34724
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Richard Lau <riclau@uk.ibm.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Mary Marchini <oss@mmarchini.me>
```
