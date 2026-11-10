Input declares `let x: string?; let y: !number;` (JSDoc nullable/non-nullable syntax in a .ts file).
Clean tsc reports a specific message ("'?' at the end of a type is not valid TypeScript syntax. Did you mean to write 'string | null | undefined'?" and the '!' equivalent).
Injected tsc reports the generic "JSDoc types can only be used inside documentation comments".
