Input is a TS file with JSDoc `@type {() => { data: string[] }}` and `@type {(a: string) => void}` annotations on functions.
The script asks the language service for quick info at `data` and at `a` inside the JSDoc.
Clean build returns no quick info (`none`); the injected build returns a bogus `any` quick info for both.
