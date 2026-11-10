#!/bin/bash
node "$TSC" --module commonjs --target es2020 --outDir out input.ts; echo "exit $?"
cat out/input.js
