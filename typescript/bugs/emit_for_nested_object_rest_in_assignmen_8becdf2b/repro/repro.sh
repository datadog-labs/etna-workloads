#!/bin/bash
node "$TSC" --target es2017 --outFile out.js input.ts
cat out.js
