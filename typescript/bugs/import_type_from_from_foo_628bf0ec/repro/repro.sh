#!/bin/bash
node "$TSC" --module commonjs --target es2015 --outDir out a.ts b.ts
echo "exit $?"
cat out/b.js
