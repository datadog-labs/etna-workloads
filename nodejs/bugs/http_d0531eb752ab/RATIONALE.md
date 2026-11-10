# Rationale

**Bug:** The `Link` header validator (`linkValueRegExp` in `lib/internal/validators.js`, used by `res.writeEarlyHints`) was too strict. It required `rel=...` to come first and allowed only one optional trailing param from a fixed list. Valid headers such as `</scripts.js>; crossorigin; rel=preload; as=script` or `...; as=script; crossorigin` were rejected with ERR_INVALID_ARG_VALUE.

**Hunk (lib/internal/validators.js):** This corresponds to the fix's only implementation hunk. The current regex is `/^(?:<[^>\r\n]*>)(?:\s*;\s*[^;"\s]+(?:=(")?[^;"\s]*\1)?)*$/`. A later change added `\r\n` to it, which is why the plain reverse didn't apply. I put back the pre-fix regex `/^(?:<[^>]*>;)\s*(?:rel=(")?[^;"]*\1;?)\s*(?:(?:as|anchor|...|referrerpolicy)=(")?[^;"]*\2)?$/`. The explanatory comment the fix added is left in place, so it is now stale.

**Failing tests:** `parallel/test-http-early-hints` and `parallel/test-http-early-hints-invalid-argument` both report "not ok". The first fails because the headers with `crossorigin` before or after `rel` are rejected. The second fails because the old regex accepts `</>; `-style input that the test expects to be rejected with ERR_INVALID_ARG_VALUE; the call throws ERR_INVALID_CHAR instead ("The validation function is expected to return true. Received false"). Both failed on two consecutive runs.
