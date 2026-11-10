#!/bin/bash
node "$TSC" --target es2015 --strict --declaration --emitDeclarationOnly --outDir out type.ts index.ts 2>&1 | head -3 | cut -c1-200
echo "exit: ${PIPESTATUS[0]}"
cat out/index.d.ts
