#!/bin/bash
node "$TSC" --target esnext --outDir out input.ts
cat out/input.js
