input.ts is an unterminated, malformed snippet (`@<[[import(obju2c77,`) that ends mid-parse, so a parse diagnostic is created past the end of the file.
Clean build clamps the diagnostic length to the source text and reports normal syntax errors.
Injected build lost the clamp, so the diagnostic length runs past EOF and the output differs (different or crashing diagnostics).
