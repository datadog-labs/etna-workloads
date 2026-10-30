Reproducer for: quicklist ziplist tail followed by extra data which starts
with 0xff (fixed upstream 2021-08-05, re-introduced by injection.patch).

What repro.sh does:
- Starts a single valkey-server with `--sanitize-dump-payload yes` and
  `--enable-debug-command yes`.
- Issues `debug set-skip-checksum-validation 1` so the crafted RDB payload
  below is accepted without a checksum match.
- Sends `RESTORE key 0 <payload> replace`, where the payload is a quicklist
  whose ziplist has one valid entry, followed by a correctly-shaped ziplist
  tail/terminator, followed by extra bytes starting with 0xff beyond the end
  of the declared ziplist length. This is the exact fuzzer payload from the
  upstream test case in tests/integration/corrupt-dump.tcl.
- Prints the RESTORE reply and whether `key` exists afterward.

Observed difference:
- Clean build (bug fixed): ziplistValidateIntegrity checks that the scan
  pointer lands exactly at the end of the ziplist allocation after the
  terminator; it doesn't, so validation fails. RESTORE replies with
  "ERR Bad data format...", and `key` does not exist (EXISTS returns 0).
- Buggy build (bug re-injected): that trailing-bytes check is missing, so
  the corrupt ziplist passes validation. RESTORE replies "OK", and `key`
  exists afterward (EXISTS returns 1). The server accepts and stores a
  malformed quicklist built from untrusted, unvalidated input.
