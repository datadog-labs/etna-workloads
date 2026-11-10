input.ts declares functions returning template literal types and `const` variables initialised from them. run.mjs asks the language service for interactive inlay hints (variable type hints) and prints each hint's display text.
Clean: the hints show the template literal types in full, as in `${string},${string}`, with substitutions escaped.
Injected: the template head, middle and tail parts aren't handled, so the hint text is wrong or missing, and the output and exit status differ.
