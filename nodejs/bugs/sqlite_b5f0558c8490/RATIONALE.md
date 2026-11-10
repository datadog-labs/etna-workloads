# sqlite: reject closing a session from a callback

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b5f0558c8490a81c16c5293c45546fd64beb934b applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: reject closing a session from a callback

SQLite runs "PRAGMA table_xinfo" from inside its pre-update hook, while
it is still walking the connection's session list. Deleting a session
from a callback that the PRAGMA triggers frees memory that walk is still
using. Both an authorizer callback and a 'sqlite.db.query' subscriber
reach that window, and either one segfaults.

Reject session.close() and Symbol.dispose when the connection is inside
any callback. An already-closed session stays a no-op so that disposal
remains idempotent.

Fixes: https://github.com/nodejs/node/issues/65428
Signed-off-by: Trevor Burnham <trevorburnham@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65454
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
