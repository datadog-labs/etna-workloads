#!/bin/bash
node "$TSC" --target esnext --useDefineForClassFields false --outFile out.js input.ts
cat out.js
