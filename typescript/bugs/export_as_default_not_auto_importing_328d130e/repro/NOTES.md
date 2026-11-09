Input: /foo.ts has `const foo = 'foo'; export { foo as default }`; /index.ts contains `foo`. The script asks the language service for auto-import completions and their details.
Clean: a "foo" completion from "./foo" is offered, with a code action adding `import foo from "./foo"`.
Injected: the default-like export name isn't resolved for `export { x as default }`, so the entry or its import code action is missing or differs.
