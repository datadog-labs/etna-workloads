# zlib: fix memory leak for unused zlib instances

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6e16ad7a63ba843aafa1284e51ce220a775e11d8 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
zlib: fix memory leak for unused zlib instances

An oversight in an earlier commit led to a memory leak
in the untypical situation that zlib instances are created
but never used, because zlib handles no longer started
out their life as weak handles.

The bug was introduced in bd201102862a194f3f5ce669e0a3c8143eafc900.

Refs: https://github.com/nodejs/node/pull/20455

PR-URL: https://github.com/nodejs/node/pull/21607
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
```
