#!/bin/bash
node "$TSC" index.js --allowJs --checkJs --strict --declaration --emitDeclarationOnly --target es2015 --outDir out
cat out/index.d.ts
