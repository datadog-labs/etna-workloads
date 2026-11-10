#!/bin/bash
node "$TSC" --target es2015 --allowJs --checkJs --declaration --emitDeclarationOnly --outDir out a.js
cat out/a.d.ts
