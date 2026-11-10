#!/bin/bash
node "$TSC" --target esnext --module esnext --outDir out input.ts
cat out/input.js
