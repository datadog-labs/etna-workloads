input.ts has `export default function () {}` followed by a partial identifier `def`; the script asks the language service for completions after `def`.
Clean: the `default` keyword completion is offered. Injected: it is missing, because the default export symbol is copied into scope and the keyword is suppressed.
