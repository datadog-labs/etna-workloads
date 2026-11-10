#!/bin/bash
node "$TSC" --target es2020 --module esnext --outDir out input.ts 2>&1
cat out/input.js
