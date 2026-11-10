Input: `type Type = (a, b, c) => void; const a: Type = (a, b) => {}`; asks the language service for signature help with the cursor right after the first parameter name `a`.
Clean: returns signature help for `Type` (argumentIndex 0).
Injected: returns no signature help ("no signature help"), because the cursor is on an identifier, not `(` or `,`.
