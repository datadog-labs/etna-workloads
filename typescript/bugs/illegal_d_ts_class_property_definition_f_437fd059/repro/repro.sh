#!/bin/bash
node "$TSC" --allowJs --declaration --emitDeclarationOnly --target es2015 --outDir out a.js
echo "exit $?"
cat out/a.d.ts
