# Rationale

**Bug.** THROW_ERR_* treats its first argument as a printf-style format string. Callers that built a message containing user input (TLS method name, addon path) and then passed it as the format string made the user input get interpreted as format directives (`%s` with no args). The result was a wrong message or a crash.

In v26.13.0 the macro skips formatting when no extra args are given, so the callsite pattern alone is no longer harmful. The reintroduction therefore also restores the old always-format behaviour of the macro.

**Hunks**
- `src/node_errors.h`: always run `SPrintF(format, args...)`, even with zero args. This is the precondition that makes the pre-formatted-message pattern dangerous again. It has no direct counterpart in the fix; it re-expresses the fix for today's code, where the macro has a zero-arg shortcut.
- `src/crypto/crypto_context.cc` (fix hunk 1, `Unknown method`): build `"Unknown method: " + *sslmethod` first, then pass it as the format string.
- `src/node_binding.cc` (fix hunk for `Module did not self-register`): snprintf into a buffer, then pass the buffer as the format string.

**Failing tests** (both stable over repeated runs)
- `parallel/test-tls-min-max-version`: `not ok`; the process aborts with `Assertion failed: (format[offset + 1]) == ('%')` (SPrintF on unsanitized `%s_method`).
- `parallel/test-process-dlopen-error-message-crash`: `not ok`; same `Assertion failed: (format[offset + 1]) == ('%')` abort for the `binding-%s.node` path.
