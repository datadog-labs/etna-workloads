# diagnostics_channel: fix default callback context

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 3294d51e5a97b1dbaf3ce3179f1bbd6b393bc5d2 applied to v26.13.0 (clean).

Upstream commit message:

```
diagnostics_channel: fix default callback context

traceCallback() defaults to a frozen context but writes the callback's
result or error to it. Allocate a fresh context when undefined is passed
and subscribers are present, matching traceSync() and tracePromise().
Set the prototype after allocation to avoid dictionary-mode properties.

Assisted-by: pi
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/66481
Reviewed-By: Bryan English <bryan@bryanenglish.com>
```
