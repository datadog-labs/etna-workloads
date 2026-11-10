Input declares ambient functions named `eval`/`arguments` inside a `declare namespace` (strict mode via --strict).
Clean build: no diagnostics (ambient functions are exempt from the strict-mode eval/arguments name check).
Injected build: reports "Invalid use of 'eval'/'arguments' in strict mode" errors for them.
