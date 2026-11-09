#!/bin/bash
node "$TSC" --target es2017 --noEmit false --outDir out input.ts 2>&1 | head -20
echo "exit: ${PIPESTATUS[0]}"
cat out/input.js 2>&1 | head -30
