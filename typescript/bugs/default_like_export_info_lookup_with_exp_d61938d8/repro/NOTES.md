Input: three in-memory modules using `export =` with a namespace that also has `export { X as default }`; the language service asks for a class-member-snippet completion (`parent`) in container.ts and its details/code actions.
Clean: default-like export info finds the `default` member, so the completion's code action adds `import Document_ from "./document.js"`.
Injected: it always treats the module as an `export =` symbol, so the output differs (the completion or its import code action is missing or wrong, and the script exits with an error).
