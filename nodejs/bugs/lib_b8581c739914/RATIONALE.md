# lib,test: fix bug in InternalSocketAddress

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b8581c7399149a90f5ffaddbd11e4d10cd7281df applied to v26.13.0 (fuzzy).

Upstream commit message:

```
lib,test: fix bug in InternalSocketAddress

InternalSocketAddress must set [kDetails] in order for the inherited
properties to function correctly.

Co-authored-by: Tobias Nießen <tniessen@tnie.de>
PR-URL: https://github.com/nodejs/node/pull/44618
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
