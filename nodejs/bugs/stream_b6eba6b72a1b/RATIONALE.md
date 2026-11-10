# stream: fix duplexify premature destroy

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b6eba6b72a1b59bb732f444291c65211e3ef9eeb applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix duplexify premature destroy

The duplexified Duplex should be autoDestroyed instead of
prematurely destroyed when the readable and writable sides
have finished without error.

Fixes: https://github.com/nodejs/node/issues/44925

PR-URL: https://github.com/nodejs/node/pull/45133
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
```
