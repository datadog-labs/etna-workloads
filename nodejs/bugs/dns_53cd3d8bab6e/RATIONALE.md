# Bug
`ERR_SOCKET_BAD_PORT` message interpolated the port directly (`${port}`), so a Symbol port made message generation throw `TypeError: Cannot convert a Symbol value to a string` instead of the intended RangeError (also poor rendering of other types).

# Change
lib/internal/errors.js, ERR_SOCKET_BAD_PORT: `Received ${determineSpecificType(port)}.` -> `Received ${port}.` (reverse of the fix's single implementation hunk, at its current location).

# Failing test
parallel/test-dns: `not ok`, with `actual: [TypeError: Cannot convert a Symbol value to a string]` where RangeError ERR_SOCKET_BAD_PORT was expected (stable over 2 runs).
