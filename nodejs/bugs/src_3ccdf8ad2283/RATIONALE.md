# Re-introduced bug: empty-named env var assertion failure (fix 3ccdf8ad2283)

**Bug.** `RealEnvStore::Set` checks whether the key starts with `=` (hidden Windows variables) via `key[0]` without checking the length. `Utf8Value::operator[]` has `CHECK_LT(index, length())`, so `process.env[''] = ''` aborts with `Assertion failed: (index) < (length())`.

**Hunk (src/node_env_var.cc, RealEnvStore::Set)** corresponds to the fix's only implementation hunk. The fix changed `if (key[0] == L'=')` to `if (key.length() > 0 && key[0] == L'=')`. I removed the `key.length() > 0 &&` guard again. The code in this release uses `'='` instead of `L'='`, and the check was inside `#ifdef _WIN32`. I also dropped the `#ifdef _WIN32` wrapper so the unguarded check runs on Linux, which is where the oracle test runs. On non-Windows, a key starting with `=` is rejected by setenv anyway, so the extra check changes nothing there except exposing the bug.

**Failing test.** `parallel/test-process-env` fails (stable over 2 runs): `Assertion failed: (index) < (length())` from `process.env[''] = ''`.
