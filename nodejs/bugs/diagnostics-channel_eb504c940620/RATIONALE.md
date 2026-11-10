# Rationale

Bug: if the only subscriber unsubscribes itself inside its onMessage handler, `channel._subscribers` becomes `undefined` (see `lib/diagnostics_channel.js` ~line 92). The `publish` loop then re-reads `.length` on undefined and throws a TypeError.

Hunk (lib/diagnostics_channel.js, `ActiveChannel.publish`): corresponds to the fix's single hunk. Today's code snapshots `const subscribers = this._subscribers` and uses `subscribers?.length || 0`. I removed the snapshot and restored the pre-fix loop: `i < this._subscribers.length` and `this._subscribers[i]`, dropping the undefined guard.

Failing test: parallel/test-diagnostics-channel-sync-unsubscribe ("not ok"; the publish throws `TypeError: Cannot read properties of undefined (reading 'length')`). Failed on both runs.
