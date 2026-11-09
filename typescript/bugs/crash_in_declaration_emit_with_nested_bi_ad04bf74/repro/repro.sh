#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2022 --outFile out.d.ts input.ts 2>&1 | head -5
echo "exit: ${PIPESTATUS[0]}"
cat out.d.ts 2>/dev/null
