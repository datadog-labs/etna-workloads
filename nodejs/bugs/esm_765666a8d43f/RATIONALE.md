# Re-introduced bug: chain advances when a loader calls next<HookName> multiple times

## Bug
The hook chain position was kept in one pointer shared by the whole chain
(`meta.current`). Each call of `next<HookName>` advanced that pointer, and every
hook was handed the same `next` function. A hook that calls `nextResolve` or
`nextLoad` twice therefore sends its second call to a later hook than the first
call reached. If the chain is already exhausted, the second call throws
`ERR_INTERNAL_ASSERTION` ("advanced beyond the end of the chain").

## Change (lib/internal/modules/esm/hooks.js, `nextHookFactory`)
This corresponds to the fix's rewrite of `nextHookFactory` in `loader.js`, which
replaced the shared `hookIndex` and `--hookIndex` with a per-hook index captured
at generation time. Today's code uses a linked list (`next`) instead of an
index, so I re-expressed the old behaviour for that.
- The per-hook recursive generation of `nextNextHook` is gone. The factory now
  returns one `nextHook` function, with `meta.current` as the shared pointer.
  This is the old `hookIndex` pointer.
- Each call advances the pointer (`meta.current = next`). This is the old
  `--hookIndex`.
- The hook is called with `nextHook` itself as its `next` argument, as it was
  before the fix.
- The "advanced too far" assertion now fires when the pointer is exhausted,
  instead of using a noop built at generation time.

## Failing test
`es-module/test-esm-loader-chaining` fails ("not ok 1"). The case "multiple calls
to next within same loader receive correct next fn" gets this on stderr instead
of an empty string:
`Error [ERR_INTERNAL_ASSERTION]: ESM custom loader 'resolve' advanced beyond the end of the chain.`
The failure was the same on two consecutive runs.
