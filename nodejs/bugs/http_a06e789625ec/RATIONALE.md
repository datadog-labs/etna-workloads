# http: fix use-after-free when freeParser is called during llhttp_execute

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a06e789625ecb46e3d6ef3e265ee15b37527c44a applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: fix use-after-free when freeParser is called during llhttp_execute

When pipelined requests arrive in one TCP segment, llhttp_execute()
parses them all in a single call. If a synchronous 'close' event
handler invokes freeParser() mid-execution, cleanParser() nulls out
parser state while llhttp_execute() is still on the stack, crashing on
 the next callback.

Add an is_being_freed_ flag that freeParser() sets via
parser.markFreed() before cleaning state. Proxy::Raw checks the flag
before every callback and returns HPE_USER to abort execution early if
set.

PR-URL: https://github.com/nodejs/node/pull/62095
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
