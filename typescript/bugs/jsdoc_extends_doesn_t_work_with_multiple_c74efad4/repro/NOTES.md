Input a.js has JSDoc `@extends {A<{ a: string, b: string }>}` with the type argument spanning multiple lines (leading `*` on each line).
Clean build skips the JSDoc leading asterisks inside the type arguments, so it parses and reports the proper type errors (for B/C/D/E as in extendsTag5).
Injected build doesn't skip them, so the multi-line type args parse wrongly and the diagnostics differ.
