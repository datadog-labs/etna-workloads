`repro.sql` runs `SELECT json(x'6B37616263162d');`, a JSONB array whose FLOAT5 element is just "-" (malformed).

- clean: `Error near line 1: malformed JSON`, exit 1.
- buggy: prints `["abc",-]`, exit 0. The `k++` lets the decoder read past the 1-byte element instead of rejecting it.

`./check.sh` failed in this sandbox (bwrap mount error), so I compared the two shells by running them directly.
