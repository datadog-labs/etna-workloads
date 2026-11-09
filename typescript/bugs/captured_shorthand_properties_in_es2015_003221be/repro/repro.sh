#!/bin/bash
node "$TSC" --noCheck --target es5 --outDir out input.ts
cat out/input.js
