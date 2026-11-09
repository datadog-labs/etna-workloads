#!/bin/bash
node "$TSC" --target es2015 --declaration --noEmit false --outDir out input.ts 2>&1 | head -c 2000
echo "exit: ${PIPESTATUS[0]}"
cat out/input.d.ts
