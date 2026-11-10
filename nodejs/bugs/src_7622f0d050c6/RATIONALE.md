# Re-introduced bug: FIPS init failure exit code

**Bug:** when `--enable-fips`/`--force-fips` fails in `ProcessFipsOptions()`, the exit code was
derived from `ERR_GET_REASON(ERR_peek_error())`. The failing path (`ncrypto::testFipsEnabled()`)
does not populate the OpenSSL error queue, so the reason is 0 and node exits with
`ExitCode::kNoFailure` (status 0) despite the failure. Reason codes are not meaningful exit codes anyway.

**Change (src/node.cc, InitializeOncePerProcessInternal):** the fix replaced the exit code with
`ExitCode::kGenericUserError` (and removed the XXX comment). I restored
`result->exit_code_ = static_cast<ExitCode>(ERR_GET_REASON(ERR_peek_error()))` plus the XXX comment,
applied to today's `if (auto fips_error = crypto::ProcessFipsOptions())` code.

**Failing test:** `parallel/test-crypto-fips` -> `not ok`, `actual: 0, expected: 1`
(assert.strictEqual(child.status, expectedStatus)); stable over repeated runs.
