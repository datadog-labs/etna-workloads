#!/bin/bash
node "$TSC" --target es2015 --module commonjs --noCheck --outDir out input.ts 2>&1 | head -3
echo "exit: ${PIPESTATUS[0]}"
cat out/input.js
