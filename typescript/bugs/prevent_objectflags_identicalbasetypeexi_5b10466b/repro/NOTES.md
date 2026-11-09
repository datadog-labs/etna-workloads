Input: a JSX file using a minimal fake `@types/react` and `Capitalize<T>` from a generic `upperFirst(...)` call used in JSX children (issue #56688).
Clean: compiles with no errors, exit 0.
Injected: tsc crashes with "TypeError: Cannot read properties of undefined (reading '0')" in removeConstrainedTypeVariables (non-intersection types wrongly treated as constrained type variables); exit 1.
