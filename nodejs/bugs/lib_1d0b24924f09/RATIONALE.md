# Bug
`validatePort(port, name, { allowZero: false })` rejected port 0 but the ERR_SOCKET_BAD_PORT message always said "should be >= 0 and < 65536", which is misleading when zero is not allowed.

# Change
lib/internal/validators.js (validatePort): `throw new ERR_SOCKET_BAD_PORT(name, port, allowZero)` -> `throw new ERR_SOCKET_BAD_PORT(name, port)`. Corresponds to the validators.js hunk of the fix. The errors.js hunk is not reverted: in today's code the message function already defaults `allowZero = true`, so omitting the argument restores the old always-`>=` message.

# Failing test
parallel/test-dgram-connect: expected message /^Port should be > 0 and < 65536/, actual 'Port should be >= 0 and < 65536. Received type number (0).'
