#!/bin/bash
rm -rf out
node "$TSC" --target es2015 --allowJs --declaration --emitDeclarationOnly --strictNullChecks --outDir out index.js Test.js test/Test.js
echo "exit: $?"
cat out/index.d.ts
