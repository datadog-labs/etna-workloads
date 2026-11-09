#!/bin/bash
node "$TSC" --target esnext --module commonjs --lib esnext --outDir out input.ts
cat out/input.js
