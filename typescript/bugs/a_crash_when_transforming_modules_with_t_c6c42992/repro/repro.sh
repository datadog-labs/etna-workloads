#!/bin/bash
node "$TSC" --target es2015 --module commonjs --outDir out input.ts 2>&1
echo "exit=$?"
cat out/input.js 2>/dev/null
