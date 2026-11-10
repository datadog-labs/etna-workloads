# Rationale
Bug: `timers/promises.setTimeout` did not validate the `delay` argument (and `scheduler.wait` dropped everything but `signal` from its options), so invalid delays such as `''` or `false` resolved instead of rejecting with ERR_INVALID_ARG_TYPE.

Hunks (lib/timers/promises.js):
1. setTimeout: removed `validateNumber(after, 'delay')` block — corresponds to the fix hunk adding it.
2. Scheduler.wait: back to `setTimeout(delay, undefined, { signal: options?.signal })` — corresponds to the fix hunk passing `options` through.
(The fix's option-validation rewrite is already equivalent in the old code paths; not reverted.)

Failing: parallel/test-timers-timeout-promisified ("not ok"): the `delay` of '' / false does not reject with ERR_INVALID_ARG_TYPE.
