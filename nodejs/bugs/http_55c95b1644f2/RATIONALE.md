# http: fix first body chunk fast case for UTF-16

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 55c95b1644f2bc2c066a60b4930de25de0e69771 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: fix first body chunk fast case for UTF-16

`http.OutgoingMessage` tried to send the first chunk together
with the headers by concatenating them together as a string, but the
list of encodings for which that works was incorrect.

Change it from a blacklist to a whitelist.

Fixes: https://github.com/nodejs/node/issues/11788
PR-URL: https://github.com/nodejs/node/pull/12747
Reviewed-By: Refael Ackermann <refack@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
