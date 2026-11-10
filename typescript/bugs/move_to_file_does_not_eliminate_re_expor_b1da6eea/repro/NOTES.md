Input: a.ts exports foo and bar; b.ts re-exports both via `export { foo, bar } from "./a"`. The script uses the language service to apply "Move to file" for `bar` from a.ts into the existing b.ts, then prints the resulting files.
Clean: the moved `bar` is inserted and `bar` is removed from b.ts's re-export, leaving `export { foo } from "./a"`.
Injected: the statements are just appended after the last statement, so the stale `bar` re-export remains in b.ts.
