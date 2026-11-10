# Rationale

**Bug:** Fatal exceptions thrown from inside an `uncaughtException` handler were reported without being "enhanced" (no decorated properties such as `rethrow: true` appended to the printed stack/inspect output). `TryCatchScope::~TryCatchScope` always passed `EnhanceFatalException::kDontEnhance` to `ReportFatalException`.

**Hunk (src/node_errors.cc, `TryCatchScope::~TryCatchScope`):** corresponds to the single implementation hunk of the fix. The fix computed `enhance = CanContinue() ? kEnhance : kDontEnhance` and passed it. I removed that computation (the code had since gained a stack-overflow branch and `ExitCode::kExceptionInFatalExceptionHandler`, which I left intact) and hard-coded `kDontEnhance` again, as before the fix.

**Failing test:** `parallel/test-unhandled-exception-rethrow-error` fails with an AssertionError: stderr does not match `/rethrow: true/` (the stack is printed but without the enhanced inspect output). Verified failing on repeated runs.
