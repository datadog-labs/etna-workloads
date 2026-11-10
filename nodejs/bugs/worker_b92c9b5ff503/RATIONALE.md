# worker: eliminate race condition in process.cwd()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b92c9b5ff5032ba890cb53b8ae70f1eb0e0ca63a applied to v26.13.0 (clean).

Upstream commit message:

```
worker: eliminate race condition in process.cwd()

Fixes a race condition in worker thread cwd caching where the counter
is incremented before the directory change completes, allowing workers
to cache stale directory values.

In lib/internal/worker.js, the main thread's process.chdir() wrapper
previously incremented the shared counter before calling the actual
chdir(), creating a race window where workers could read the old
directory but cache it with the new counter value. This caused
subsequent cwd() calls to return incorrect paths until the next chdir().

This fix reorders the operations to change the directory first, then
increment the counter, ensuring workers are only notified after the
directory change completes.

Before fix: 54.28% error rate (311/573 races)
After fix: 0% error rate (0/832 races)

Refs: https://hackerone.com/reports/3407207
Co-authored-by: Giulio Comi
Co-authored-by: Caleb Everett
Co-authored-by: Utku Yildirim
PR-URL: https://github.com/nodejs/node/pull/61664
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
```
