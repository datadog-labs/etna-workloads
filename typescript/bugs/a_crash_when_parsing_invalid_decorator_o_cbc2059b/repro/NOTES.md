Input: a decorator `@dec` followed by `await 1` at top level (invalid decorator on an await expression).
Clean: tsc reports normal diagnostics (e.g. declaration expected / decorator errors).
Injected: parser treats `await` after decorators as a declaration and hits a Debug.assert, so tsc crashes with a Debug Failure stack trace instead.
