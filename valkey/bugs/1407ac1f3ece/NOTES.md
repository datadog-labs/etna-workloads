repro.sh starts a server and runs BITPOS with invalid arguments (non-integer start, bad unit, extra args) against a non-existing key.
Clean build: returns syntax / "not an integer" errors, as it does for an existing key.
Buggy build: looks up the key first and replies 0 / -1 for the missing key before validating arguments.
