# child_process: use signal.reason in child process abort

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2dc4290662d57e378f9b8902b426940a5200be1a applied to v26.13.0 (fuzzy).

Upstream commit message:

```
child_process: use signal.reason in child process abort

Fixes: https://github.com/nodejs/node/issues/47814
PR-URL: https://github.com/nodejs/node/pull/47817
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Darshan Sen <raisinten@gmail.com>
```
