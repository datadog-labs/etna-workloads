# worker: fix heap snapshot crash on exit

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 448d5d1a19924b62796b63bc7e598303b15f003f applied to v26.13.0 (fuzzy).

Upstream commit message:

```
worker: fix heap snapshot crash on exit

Worker.parent_port_ can be released before the exit event of Worker. The
parent_port_ is not owned by `node::worker::Worker`, thus the reference
to it is not always valid, and accessing it at exit crashes the process.

As the Worker.parent_port_ is only used in the memory info tracking, it
can be safely removed.

PR-URL: https://github.com/nodejs/node/pull/43123
Fixes: https://github.com/nodejs/node/issues/43122
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
