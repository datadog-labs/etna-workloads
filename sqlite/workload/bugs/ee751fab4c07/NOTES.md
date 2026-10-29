`VACUUM INTO x;` (bare identifier as filename expression).
Clean shell: `Parse error: no such column: x`. Buggy shell skips name resolution of the INTO expression, so the unresolved column reaches code generation (assertion failure/crash or wrong error instead of the error).
