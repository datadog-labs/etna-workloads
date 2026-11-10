#!/bin/bash
node "$TSC" --experimentalDecorators --target es2022 --outFile out.js input.ts
cat out.js
