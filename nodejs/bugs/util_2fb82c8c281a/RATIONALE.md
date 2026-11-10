# Rationale

Bug: util.inspect of error objects was not defensive. Throwing getters for `stack`, `name`, `message`, `errors`
made inspect throw, and `isError` used `e instanceof Error`, which invokes a user-overridable `Symbol.hasInstance`.

Hunks (all re-expressed for the current code):
- lib/internal/util.js: `isError` uses `e instanceof Error` again (fix hunk 1; drops the FunctionPrototypeSymbolHasInstance import).
- inspect.js `getStackString`: reads `error.stack` directly without try/catch (fix hunk on getStackString).
- inspect.js `formatError`: no try/catch around getStackString (no `ObjectPrototypeToString` fallback), reads `err.name`/`err.message`
  directly, and key-hiding is the old loop over name/message/stack (the old removeDuplicateErrorKeys logic, inlined); `err.errors` read without try/catch. ObjectPrototypeToString import removed.

Failing: parallel/test-util-inspect (not ok, stable over 2 runs); the new test throws "Error" from the throwing getter / hasInstance mustNotCall instead of printing `[object Error] {...}`.
