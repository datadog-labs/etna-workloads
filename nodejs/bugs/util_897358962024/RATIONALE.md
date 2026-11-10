# Rationale

**Bug:** When `util.inspect` highlights `node_modules` in error stacks, namespaced packages (`@scope/pkg`) only had the scope (`@scope`) underlined, not the full `@scope/pkg` name.

**Change (lib/internal/util/inspect.js, `markNodeModules`):** Removed the `else if (line[moduleStart] === '@') {...}` branch that extended `moduleEnd` past the second separator for namespaced modules. This corresponds to the fix's hunk adding the `if (line[moduleStart] === '@')` extension. (The release's code had since been reworked with extra -1 handling, so a literal reverse did not apply.) Without it, the module name ends at the first separator, as before the fix.

**Failing test:** `parallel/test-util-inspect` reports `not ok` (the colored-stack assertion with `node_modules/@namespace/bar` expects the full `@namespace/bar` underlined). It failed on two consecutive runs.
