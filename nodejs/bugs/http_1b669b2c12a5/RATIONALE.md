# Re-introduced bug: http `.end()` corks even when it is a noop

**Bug.** `OutgoingMessage.prototype.end()` corked the socket unconditionally at entry. When `.end()` was called again after the message was already finished (or with a chunk after finish), it returned early without uncorking. That left the socket corked (nodejs/node#36620).

**Change (lib/_http_outgoing.js, one logical hunk set).**
- Removed the `this[kSocket].cork()` inside `if (chunk)`, after the `this.finished` check. This corresponds to the fix's added cork in the `if (chunk)` branch.
- Removed the `this[kSocket].cork()` inside `else if (!this._header)`. This corresponds to the fix's added cork in that branch.
- Added an unconditional `this.cork()` at the top of `end()`, before `if (chunk)`. This corresponds to the fix's removed top-level `if (this.socket) this.socket.cork()`. The release tracks the cork count in `kCorked` (`writableCorked`) rather than reading it from the socket. So the top-level cork uses `this.cork()`, which increments `kCorked` and corks the socket. A noop `end()` on a finished message therefore leaves it corked, as before the fix.

**Failing test.** `parallel/test-http-outgoing-end-multiple` fails on the second `res.end()` check: `assert.strictEqual(res.writableCorked, 0)` gets actual 1, expected 0. It failed on both runs. It passes on the clean release.
