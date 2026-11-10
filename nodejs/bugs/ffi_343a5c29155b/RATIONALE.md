# ffi: fix use-after-free in PrepareFunction

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 343a5c29155bdfb8ac74c6588b07aa1e73fea22b applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: fix use-after-free in PrepareFunction

PrepareFunction() looked up the function cache before parsing the
signature. Parsing can run user getters, and a getter that calls
lib.close() clears the cache, which invalidates the iterator. For a
function that was already cached, reading it afterwards used freed
memory and crashed the process.

Look up the cache after the signature is parsed. If the library was
closed during parsing, ResolveSymbol() now throws
ERR_FFI_LIBRARY_CLOSED.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66368
Fixes: https://github.com/nodejs/node/issues/66367
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
```
