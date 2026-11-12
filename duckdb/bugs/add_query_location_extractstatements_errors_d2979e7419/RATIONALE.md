# Rationale

Hunk: src/main/connection.cpp, `Connection::ExtractStatements`.
Traces to the fix's single hunk. Today's code already had the fix's try/catch (ErrorData + `ProcessError(error, query)` + `Throw`) around the iterator drain. I removed it, so the drain loop is unguarded again and parse errors lose their query location (`LINE 1:` and carets).

Oracle result (1 of 38 oracle units fail):
FAIL cpp:test/api/test_api.cpp::Test ExtractStatements error location
  ... "exception_message":"VALUES lists must all be the same length, ..." contains: "LINE 1: FROM (VALUES ('1', '2'), ('1'))"
The other 37 units pass in my run.
