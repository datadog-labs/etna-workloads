#!/bin/bash
node "$TSC" --module commonjs --target es2017 --outDir out input.ts
cat out/input.js
