# Timer leak (nodejs/node#53335)

Bug: timers whose id was coerced to a primitive (`+timer`) are stored in `knownTimersById`. When such a timer fires/is destroyed in the internal timer processing (`listOnTimeout`), the entry was not removed, so the map kept the Timeout alive forever (leak, never GC'd).

Change (lib/internal/timers.js only): removed the two `if (timer[kHasPrimitive]) delete knownTimersById[asyncId];` blocks in `listOnTimeout` (the `!timer._onTimeout` branch and the `!_idleNext && !_idlePrev && !_destroyed` branch). These correspond to the two `listOnTimeout` hunks added by the fix. The fix's move of `knownTimersById` into internal/timers is a refactor that the release already contains, so it is left as-is (needed for the other, unchanged `unenroll` delete).

Failing test: parallel/test-primitive-timer-leak — "not ok", timeout (exitcode -15): onGC never fires for all 10 timers, so the poller interval is never cleared.
