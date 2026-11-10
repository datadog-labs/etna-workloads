Runs the language service's organizeImports on a file whose `export { ... } from './a'` specifiers carry `/** @deprecated */` JSDoc comments.
Clean: the JSDoc comment on the first specifier is preserved in the output.
Injected: the first specifier's deprecated comment is dropped (leading trivia suppressed); the others remain.
