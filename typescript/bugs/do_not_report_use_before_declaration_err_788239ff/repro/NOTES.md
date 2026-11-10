Input: a `const iter = (function* () { iter; yield 1; })();` — a sync generator IIFE referencing the variable being initialized.
Clean: reports TS2448 (used before its declaration), since generator IIFEs are not treated as same-scope.
Injected: only async functions are excluded, so the generator IIFE is treated as same-scope and the error is missing.
