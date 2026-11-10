# Re-introduced bug
`net.Socket` accepts `objectMode`, `readableObjectMode` and `writableObjectMode` options instead of throwing `ERR_INVALID_ARG_VALUE` ("is not supported"). That lets a TCP socket be put into object mode, which it does not support (nodejs/node#40336).

## Hunk
`lib/net.js`, `Socket()`: the fix added a block at the top of the constructor that throws for those three options. Today's code spells it as an if/else-if on `options?.objectMode` / `readableObjectMode` / `writableObjectMode`, so a plain reversal doesn't apply. I deleted that block, which restores the pre-fix behaviour of no validation.

## Failing tests
Both fail with the change: `parallel/test-socket-options-invalid` and `parallel/test-net-connect-options-invalid`. Each run threw nothing where the test expected `ERR_INVALID_ARG_VALUE` with message `/The property 'options.objectMode' is not supported. Received true/`. I ran both twice with the same result.
