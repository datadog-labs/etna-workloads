# test: ensure removeListener event fires for once() listeners

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 8fd5f6be79aa992c4b5130f403d2ba7a69f87d8d applied to v26.13.0 (fuzzy).

Upstream commit message:

```
test: ensure removeListener event fires for once() listeners

Adds test coverage for the removeListener event being emitted
when a once() listener is automatically removed after execution.
This verifies that streams and other EventEmitters correctly
emit removeListener events when once() wrappers clean up.

PR-URL: https://github.com/nodejs/node/pull/60137
Fixes: https://github.com/nodejs/node/issues/59977
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```
