tsconfig.json has `"extends": ""` and input.ts has a type error; repro.sh runs `tsc -p tsconfig.json`.
Clean build reports "Compiler option 'extends' cannot be given an empty string".
Injected build treats "" as no extends and reports "File '' not found" instead (or no extends diagnostic).
