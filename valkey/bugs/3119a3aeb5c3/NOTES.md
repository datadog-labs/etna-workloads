repro.sh starts one server and sends `CLIENT KILL id 0|-1`, `CLIENT LIST id 0|-1` and `CLIENT LIST not-id 0|-1`.

Clean build: every call replies "ERR client-id should be greater than 0".
Buggy build: the ID check is gone for `id`. `CLIENT KILL id 0|-1` replies 0 and `CLIENT LIST id 0|-1` returns an empty list, in both cases instead of the error. `not-id` still errors, because it has a separate check.
