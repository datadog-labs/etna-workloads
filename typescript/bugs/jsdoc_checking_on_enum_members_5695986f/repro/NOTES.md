input.ts imports a type only referenced via a JSDoc {@link A} on an enum member, with --noUnusedLocals.
Clean: no diagnostics (the link counts as a use). Injected: error TS6133 "'A' is declared but its value is never read".
