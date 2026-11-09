#!/bin/bash
node "$TSC" --target es2015 --experimentalDecorators --ignoreDeprecations 6.0 --outDir out input.ts
cat out/input.js
