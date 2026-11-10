#!/bin/bash
node "$TSC" --target es2022 --outFile out.js input.ts
cat out.js
