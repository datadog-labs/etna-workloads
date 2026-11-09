#!/bin/bash
node "$TSC" --target esnext --lib esnext --strict --removeComments false --outDir out input.ts
cat out/input.js
