# lib: fix AbortSignal.any() nested composite leak

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 447c36cb4527235e9a1a5b837ed1bc6c7f2e6633 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix AbortSignal.any() nested composite leak

AbortSignal.any() copies the source WeakRefs of a composite input into
the new composite, so nested composites share them. Those WeakRefs were
also used as the unregister tokens for the registrations that prune a
composite's sources once they are collected. When an inner composite
was collected first, its cleanup therefore also unregistered the outer
composite from the same sources. An observed outer composite then
stayed in gcPersistentSignals, together with its listeners, even after
all of its sources were gone and nothing could abort it anymore.

Use each composite's own WeakRef as the unregister token instead, so
collecting one composite only removes its own registrations.

Fixes: https://github.com/nodejs/node/issues/66612
Refs: https://github.com/nodejs/node/pull/62367
Assisted-by: Claude Code
Signed-off-by: journaltraces <kxenk@protonmail.com>
PR-URL: https://github.com/nodejs/node/pull/66617
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```
