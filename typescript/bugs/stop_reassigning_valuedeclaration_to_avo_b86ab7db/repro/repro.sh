#!/bin/bash
node "$TSC" --target esnext --lib esnext --strict --allowJs --checkJs --declaration --emitDeclarationOnly --outDir dist index.js
echo "exit: $?"
cat dist/index.d.ts
