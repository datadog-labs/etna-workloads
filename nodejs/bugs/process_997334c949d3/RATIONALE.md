# process: fix uid/gid validation to avoid crash

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 997334c949d3dd44dfd45053fd0aa05adb66ca9d applied to v26.13.0 (clean).

Upstream commit message:

```
process: fix uid/gid validation to avoid crash

id |= 0 turns unsigned 32-bit integer values exceeding the unsigned
31-bit range into negative integers, causing a crash. Use id >>>= 0
instead, which works properly for all unsigned 32-bit integers.

Refs: https://github.com/nodejs/node/pull/36786
PR-URL: https://github.com/nodejs/node/pull/44910
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Erick Wendel <erick.workspace@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
