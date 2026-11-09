#!/bin/bash
node "$TSC" --module system --target es2015 --outDir out input.ts
cat out/input.js
