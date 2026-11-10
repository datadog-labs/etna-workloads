#!/bin/bash
node "$TSC" --module commonjs --target es2015 --outDir out input.ts
cat out/input.js
