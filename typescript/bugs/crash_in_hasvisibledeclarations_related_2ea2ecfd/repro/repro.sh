#!/bin/bash
node "$TSC" --strict --target esnext --lib esnext --declaration --emitDeclarationOnly --outDir out input.ts >log.txt 2>&1
echo "exit: $?"
grep -E "TypeError|error TS" log.txt
cat out/input.d.ts 2>/dev/null
