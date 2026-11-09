#!/bin/bash
node "$TSC" --target es2015 --outFile out.js input.ts
cat out.js
