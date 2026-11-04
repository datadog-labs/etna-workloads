Reproducer: `repro.sql` calls `encode()` on non-UTF-8 binary input (a raw 20-byte `X'8f50...'` literal, and `digest('hello','sha256')`) with `hex` and `base64`.

Clean build: returns the hex/base64 strings, and `arrow_typeof` is `Utf8`.
Buggy build: `encode` returns Binary-typed output, so each statement fails with "Optimizer rule 'simplify_expressions' failed ... Encountered non UTF-8 data".
