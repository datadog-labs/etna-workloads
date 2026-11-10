#!/bin/bash
node "$TSC" --target es2015 --module amd --outFile out.js input.ts 2>&1 || true
cat out.js
