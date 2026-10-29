Creates a STRICT table with an ANY column holding int, real, text, blob and NULL values, then runs `PRAGMA integrity_check(t2)`.
Clean shell prints `ok`. The buggy shell type-checks ANY columns with a mask that only allows blobs, so it reports bogus "non-ANY value in t2.b" errors.
