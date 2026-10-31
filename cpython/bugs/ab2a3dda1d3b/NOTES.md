Creates `ContextVar` with an unhashable `str` subclass as the name. Hash computation fails, so the
half-built var is deallocated. Clean: prints `TypeError unhashable type: 'S'` then `done` (exit 0).
Buggy: the hash is computed before the var's fields are initialised, so the failure path
deallocates a partially initialised object and the interpreter segfaults (exit -11).
