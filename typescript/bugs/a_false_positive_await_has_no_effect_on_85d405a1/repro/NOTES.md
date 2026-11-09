input.ts has an async function whose parameter type is a generic `T extends Promise<void> | void`, and the function does `await a`.
repro.sh runs the language service's getSuggestionDiagnostics on it (with the real default lib).
Clean: no suggestion diagnostics. Injected: a false-positive 80007 "'await' has no effect on the type of this expression", because the constraint union is no longer checked per member for thenables.
