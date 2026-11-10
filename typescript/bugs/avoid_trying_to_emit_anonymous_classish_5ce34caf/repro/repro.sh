#!/bin/bash
node "$TSC" --allowJs --checkJs --declaration --emitDeclarationOnly --target es2015 --outFile out.js file.js
cat out.d.ts 2>/dev/null || cat file.d.ts
