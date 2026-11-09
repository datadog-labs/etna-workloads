#!/bin/bash
node "$TSC" --target es2017 --lib esnext --noEmit false --outFile out.js input.ts
cat out.js
