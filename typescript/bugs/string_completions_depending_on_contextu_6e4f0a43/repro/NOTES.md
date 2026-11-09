Input: xstate-style `sendTo((ctx) => ctx.child, { type: "" })` where the string literal's type depends on a context-sensitive signature.
The script requests string-literal completions inside the `""` via the language service.
Clean: returns `["EVENT"]`. Injected: completions are `null` (no string-literal completions offered).
