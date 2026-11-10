#!/bin/bash
node "$TSC" --target es2015 --outDir out input.ts
cat out/input.js
