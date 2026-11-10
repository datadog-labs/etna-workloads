Input: a JS class whose constructor carries a JSDoc `@callback ValueGetter_2` with `@returns {boolean|number|string|undefined}`; the typedef is then used via `@type`.
The d.ts emit prints the type of `ooscope2`.
Clean: `(name: string) => boolean | number | string | undefined`. Injected: the explicit @returns is ignored and the return type becomes `Preferences`.
