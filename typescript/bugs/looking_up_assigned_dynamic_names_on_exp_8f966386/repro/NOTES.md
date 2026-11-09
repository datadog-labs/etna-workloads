input.ts assigns a const-string-keyed property (`expr2[s] = 0`) onto an exported function expression and an arrow function (expando with dynamic name), under --strict.
Clean: no errors (the assigned dynamic name is found on the function expression).
Injected: TS7053 "Element implicitly has an 'any' type ... Property 'X' does not exist on type '() => void'" on both assignments.
