#!/bin/bash
node "$TSC" --target esnext --module commonjs --outDir out input.ts
cat out/input.js
