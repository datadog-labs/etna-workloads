#!/bin/bash
rm -rf out; node "$TSC" --target es2022 --outDir out input.ts 2>&1
echo "exit: $?"
cat out/input.js
