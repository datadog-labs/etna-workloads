input.ts has a top-level label (`subTitle:`) whose body is `export const title: string` (a declaration-only export that emits nothing).
Compiled with `--module commonjs`, the clean build emits JS with an empty statement for the label.
The injected build hits a Debug.checkDefined failure (crash, non-zero exit) because the labeled statement's body visits to undefined.
