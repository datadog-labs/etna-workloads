#!/bin/bash
node "$TSC" --jsx react --target es2015 --outDir out input.tsx
cat out/input.js
