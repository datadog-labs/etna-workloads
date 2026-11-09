#!/bin/bash
node "$TSC" --rewriteRelativeImportExtensions --module esnext --target esnext --outDir out input.ts
cat out/input.js
