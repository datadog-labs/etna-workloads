#!/bin/bash
node "$TSC" --isolatedModules --module amd --target es2015 --outFile /dev/stdout input.ts 2>&1 || true
node "$TSC" --isolatedModules --module amd --target es2015 --outDir out input.ts; cat out/input.js
