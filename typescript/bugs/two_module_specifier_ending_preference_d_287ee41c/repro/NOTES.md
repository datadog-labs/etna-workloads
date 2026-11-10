Language-service "add import" code fix for undefined `c` in main.ts (bundler resolution), which also imports "./a.mjs" and "./b".
Clean ignores the `.mjs` import when inferring ending preference (not optional), so it suggests `./c`.
Injected counts `./a.mjs` as a JS-extension preference, so the fix suggests `./c.js`.
