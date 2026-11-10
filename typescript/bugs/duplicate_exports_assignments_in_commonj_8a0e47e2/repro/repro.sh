#!/bin/bash
node "$TSC" --target es2015 --module commonjs --outDir out input.ts
cat out/input.js
