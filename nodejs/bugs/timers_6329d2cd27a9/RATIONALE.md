# Bug: `timers.promises` not exported

`require('timers').promises` was missing, so it was `undefined` and not equal to `require('timers/promises')`.

## Changes (lib/timers.js only)
- Removed the `ObjectDefineProperties(timers, { promises: {...getter} })` block (fix's last hunk).
- `module.exports = timers = {` -> `module.exports = {`, and dropped `let timers;` and the `ObjectDefineProperties` primordial import (fix's hunks 1-3, 5). `timersPromises` itself is kept because the customPromisify getters use it.

## Failing test
parallel/test-timers-promises: `not ok` — assert.deepStrictEqual(timerPromises, timer.promises) fails because `timer.promises` is undefined. Stable across two runs.
