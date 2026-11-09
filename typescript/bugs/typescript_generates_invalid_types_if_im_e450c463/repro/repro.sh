#!/bin/bash
node "$TSC" --target es2015 --declaration --emitDeclarationOnly --allowJs --checkJs --outDir out a.ts b.js
echo "exit $?"
cat out/b.d.ts
