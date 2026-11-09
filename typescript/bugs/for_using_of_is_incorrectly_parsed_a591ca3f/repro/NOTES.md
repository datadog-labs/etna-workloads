Input: `for (using of = null; ;) { break; }` — a `using` declaration whose variable is named `of`.
Clean build parses it as a using declaration (`of` is the binding) and emits it with no syntax errors.
Injected build rejects `of` after `using` in a for head, so it parses differently and reports syntax errors.
repro.sh runs tsc on it and prints the emitted JS/diagnostics.
