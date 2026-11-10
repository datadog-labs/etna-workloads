Input: a TS file with a JSDoc `@returns {function(): string}` on a function; the script requests language-service completions at the position right after `function` inside the JSDoc type.
Clean: completions are returned (prints `<pos> true`).
Injected: the completion request crashes (function-like node's symbol type gets cached/reset), so it prints `<pos> crash`.
